% Initial design point
% Script to calculate the initial feasible design

clc;
close all;
clear all;

%% standard variables
g = 9.816;

%% Weight data [kg]
OEW    = 40800 * g;
MZFW   = 58500 * g;
MLW    = 62500 * g;
MTOW   = 75500 * g;
Wconst = 44900 * g;                                 % Weight of the aircraft minus wing and fuel [N]

%% Performance
R = 7963.6e3;                                       % Design range [m] = 4300 [nm]
Ct = 1.8639e-4;                                     %specific fuel consumption [N/Ns] 

%% Flight condition (cruise)
flightCondition.V   = 828/3.6;                      % flight speed (m/s)
flightCondition.rho = 0.2981*1.225;                 % air density  (kg/m3)
flightCondition.alt = 11000;                        % flight altitude (m)
flightCondition.M   = 0.78;                         % flight Mach number 
flightCondition.loadCondition = 0;                  % Specifies whether flown at max loading or not. 0 is not, 1 is

%% Estimate Wfuel

cruiseRatio = exp(((R*Ct)/flightCondition.V)*(1/16)); 
Wfuel = (1-0.938*(1/cruiseRatio))*MTOW;             % [N]

%% Planform data
I(1) =  34.10 ;                                     % b [m]
I(2) =  8 ;                                       % Croot
I(3) =  0.5  ;                                     % lambda_outer
I(4) =  25    ;                                     % Sweep [deg]

% scaled front and back
% I(5:16)  =   [0.2884    0.0987    0.3301    0.1109    0.3431    0.4711   -0.2782   -0.2020   -0.0573   -0.5899    0.0914    0.4015];   % airfoil at root
% I(17:28) =   [0.0961    0.0329    0.1100    0.0370    0.1144    0.1570   -0.0927   -0.0673   -0.0191   -0.1966    0.0305    0.1338];   % airfoil at tip

% from tutorial
 I(5:16)  =   [0.2337    0.0800    0.2674    0.0899    0.2779    0.3816   -0.2253   -0.1637   -0.0464   -0.4778    0.0741    0.3252];   % airfoil at root
% I(17:28) =   [0.2337    0.0800    0.2674    0.0899    0.2779    0.3816   -0.2253   -0.1637   -0.0464   -0.4778    0.0741    0.3252];   % airfoil at tip

% Both slim
%I(5:16)  =   [0.0961    0.0329    0.1100    0.0370    0.1144    0.1570   -0.0927   -0.0673   -0.0191   -0.1966    0.0305    0.1338];   % airfoil at root
I(17:28) =   [0.0961    0.0329    0.1100    0.0370    0.1144    0.1570   -0.0927   -0.0673   -0.0191   -0.1966    0.0305    0.1338];   % airfoil at tip

%Start of surrogate variables
I(29:34) =  [4.8 4 3.5 3.4 3.3 1.6] .*1e4  ;                  % Lift distribution
I(35:40) =  [-1.25 -1.0 -0.8 -0.45 -0.4 -0.2] .*1e5 ;    % Pitching moment distribution
I(41) =   MTOW-Wfuel-Wconst;                        % Wing weight star [N]
I(42) =   Wfuel;                                    % Fuel weight star [N]

%% Weight results
disp(['MTOW (ref)  : ' num2str(MTOW)]);
disp(['MTOW (calc) : ' num2str(Wconst + I(41) + I(42))]);
disp(['Wfuel       : ' num2str(Wfuel)]);
disp(['Wwing       : ' num2str(I(41))]);
disp(['MZFW(actual): ' num2str(MZFW)]);
disp(['MZFW(calc)  : ' num2str(MTOW-Wfuel)]);

%% Analyze fueltank
Vtank = fuelTankCalc(I);
Vspare = -(((Wfuel/g)/(0.81715e3))-(0.93*Vtank));
disp(['fuel tank capacity  : ' num2str(Vtank)]);
disp(['capacity needed     : ' num2str((Wfuel/g)/(0.81715e3))]);
disp(['capacity left       : ' num2str(Vspare)]);

%% Run aerodynamic analysis at cruise
visc = 1;
[aeroResults] = aeroSolver(I, visc, flightCondition);



%% Run aerodynamic analysis at max loading

% Flight condition (max load)
flightCondition.V   = 871/3.6;                      % flight speed (m/s)
Vcruise = flightCondition.V;
flightCondition.rho = 0.2981*1.225;                 % air density  (kg/m3)
flightCondition.alt = 11000;                        % flight altitude (m)
flightCondition.M   = 0.82;                         % flight Mach number 
flightCondition.loadCondition = 1;                  % Specifies whether flown at max loading or not. 0 is not, 1 is

% Run aerodynamic analysis at max loading
visc = 0;
[aeroMaxLoadResults] = aeroSolver(I, visc, flightCondition);
chords = aeroMaxLoadResults.Wing.chord;

% Analyze wing loading given by surrogate variables and Q3D

% Q3D results
load.L = aeroMaxLoadResults.Wing.ccl;
load.T = aeroMaxLoadResults.Wing.cm_c4;

% Surrogate variables
load.LPoints = I(29:34);
load.TPoints = I(35:40);
load.Y = linspace(0,1,14);
load.ycontrolpoints = linspace(0,1,6);

load.Lstar = BezierCurve(length(load.Y), [load.ycontrolpoints' load.LPoints']);
load.Tstar = BezierCurve(length(load.Y), [load.ycontrolpoints' load.TPoints']);

% Calculate some additional data to transform results to forces and moments
q = 0.5*flightCondition.rho*flightCondition.V^2;   % dynamic pressure
percentKink = 0.3;
b = I(1);
cRoot = I(2);
taper = I(3);
sweep = I(4);

y(1) = 0;
y(2) = percentKink*0.5*b;
y(3) = 0.5*b;
x(1) = 0;
x(2) = y(2) * tan(sweep);
x(3) = y(3) * tan(sweep);
c(1) = cRoot;
c(2) = c(1) - y(2)*(tan(sweep) + tan(0.0001*pi/180));
c(3) = c(2) * taper;
S = 2*(((c(1)-c(2)/2)+c(2))*y(2) + ((c(3)-c(2)/2)/2)*(y(3)-y(2)));
fullTaper = c(3)/c(1);
MAC = c(1) * (2/3) * ((1 + fullTaper + fullTaper^2)/(1 + fullTaper));

% Transform lift distribution
load.L = load.L * q;
%load.Lstar = load.Lstar * q;

% Transform moment distribution
load.T = (load.T .* chords) * q * MAC;
%load.Tstar = (load.Tstar .* chords) * q * MAC;

% Plot for comparison
figure();
plot(load.Y, load.L, 'r', load.Y, load.Lstar, 'g');
title('Lift distribution');
xlabel('wing position [x/0.5b]');
ylabel('Lift [N]');
legend('actual load', 'surrogate variables');

figure();
plot(load.Y, load.T, 'r', load.Y, load.Tstar, 'g');
title('Pitching moment distribution');
xlabel('wing position [x/0.5b]');
ylabel('Cm [Nm]');
legend('actual load', 'surrogate variables');

% AS.L = interp1(Res.Wing.Yst,Res.Wing.ccl*q,AS.Y*I.Wing(1).Span/2,'spline'); %lift distribution
% AS.T = interp1(Res.Wing.Yst,Res.Wing.cm_c4.*Res.Wing.chord*q*MAC,AS.Y*I.Wing(1).Span/2,'spline'); % pitching moment distribution

%% Run the structure solver and compare with given in value
Wwing = strucSolver(I);
disp(['Wwing(calc) : ' num2str(Wwing)]);
disp(['Wwing(guess): ' num2str(I(41))]);
disp(['Difference  : ' num2str(Wwing-I(41))]);

%% Determine and compare wing loading 
WingLoadMax = (MTOW/g)/S; %maximum
wingLoadingDes = 522.88;
disp(['current W/S [kg/m^2] : ' num2str(WingLoadMax)]);
disp(['Des W/S [kg/m^2]     : ' num2str(wingLoadingDes)]);

%% Calculate the A-W group drag contribution
CDaircraft = (aeroResults.CLwing / 16) - aeroResults.CDwing;
D = 0.5 * flightCondition.rho * (Vcruise^2) * S * CDaircraft;
CDtotal = CDaircraft + aeroResults.CDwing;

disp(['CD wing [ ] : ' num2str(aeroResults.CDwing)]);
disp(['CD rest [ ] : ' num2str(CDaircraft)]);
disp(['CD total[ ] : ' num2str(CDtotal)]);
disp(['CL/CD   [ ] : ' num2str(aeroResults.CLwing / CDtotal)]);
disp(['Drag    [N] : ' num2str(D)]);

