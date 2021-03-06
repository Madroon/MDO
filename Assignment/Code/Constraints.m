% Constraints
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Constraint function calculates constraints on basis of the design vector
% 
% Input:    X
% Output:   cEq - equality constraints
%           cIn - inequality constraints

function [cEq, cIn] = Constraints(X)

%% Input Constants -> Wconst
Constants;

%% Remove scaling
X = X' .* I;

%% Take apart input vector and do some initial planform calculations
% X(1) = b
% X(2) = Croot
% X(3) = lambda_outer
% X(4) = sweep
% X(5) - X(16) = airfoil at root
% X(17) - X(28) = airfoil at tip
% Start of surrogate variables
% X(29) - X(34)Lift distribution
% X(35) - X(40)Pitching moment distribution
% X(41) = Wing weight star
% X(42) = Fuel weight star

b = X(1);
cRoot = X(2);
taper = X(3);
sweep = X(4)*pi/180;

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

%% Run aerodynamic solver at cruise (viscous) -> L/D wing
visc = 1;
flightCondition.V   = Vcruise;           % flight speed (m/s)
flightCondition.rho = rho;         % air density  (kg/m3)
flightCondition.alt = alt;         % flight altitude (m)
flightCondition.M   = Mcruise;           % flight Mach number 
flightCondition.loadCondition = 0;                  % Specifies whether flown at max loading or not. 0 is not, 1 is

[aeroCruiseResults] = aeroSolver(X, visc, flightCondition);

%% Run aerodynamic solver at max load (inviscid) -> lift + pitch distribution
visc = 0;
flightCondition.V   = Vmax;           % flight speed (m/s)
flightCondition.rho = rho;          % air density  (kg/m3)
flightCondition.alt = alt;         % flight altitude (m)
flightCondition.M   = Mmax;           % flight Mach number 
flightCondition.loadCondition = 1;                  % Specifies whether flown at max loading or not. 0 is not, 1 is

[aeroMaxLoadResults] = aeroSolver(X, visc, flightCondition);

% extract the distributions
load.L = aeroMaxLoadResults.Wing.ccl;
load.T = aeroMaxLoadResults.Wing.cm_c4;
q = 0.5*flightCondition.rho*flightCondition.V^2;   % dynamic pressure
load.L = load.L * q;
load.T = (load.T .* aeroMaxLoadResults.Wing.chord) * q * MAC;

% Calculate lift and pitch moment distribution from surrogate variables and Bezier curves
load.LPoints = X(29:34);
load.TPoints = X(35:40);
load.Y = linspace(0,1,14);
load.ycontrolpoints = linspace(0,1,6);
load.Lstar = BezierCurve(length(load.Y), [load.ycontrolpoints' load.LPoints']);
load.Tstar = BezierCurve(length(load.Y), [load.ycontrolpoints' load.TPoints']);

%% Run structural solver -> Wstr,wing
[Wwing] = strucSolver(X);
%% Calculate performance characteristics -> Wfuel

% Still needs to take into account the different drag contribution of the
% rest of the aircraft
CDrest = (2*Drest) / (rho * S * Vcruise^2); 
CDtotal = CDrest + aeroCruiseResults.CDwing;
cruiseRatio = exp((R*Ct*CDtotal)/(Vcruise * aeroCruiseResults.CLwing));
fuelFraction = 1-0.938*(1/cruiseRatio);
Wfuel = (Wconst + Wwing)/((1/fuelFraction)-1); 

%% Calculate MTOW
wingLoading = ((Wconst + Wwing + Wfuel)/g) / S; 

%% Fuel tank calculations
[Vtank] = fuelTankCalc(X);

%% Equality constraints

% Surrogate values checking 
cEq(1) = (X(41) - Wwing)/I(41);                         % surrogate variable on wing weight
cEq(end+1) = (X(42) - Wfuel)/I(42);                     % surrogate variable on fuel weight
cEq(end+1) = sum(load.L - load.Lstar);          % surrogate load distribution
cEq(end+1) = sum(load.T - load.Tstar);          % surrogate pitch moment distribution


%% Inequality constraints
cIn(1) = (((Wfuel/g)/(0.81715e3))-(0.93*Vtank))/VtankRestRef; %Check volume of the fuel tank
cIn(end+1) = (wingLoading/wingLoadingDes) - 1;       %Check that wing loading hasn't increased
end
