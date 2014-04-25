% aeroSolver
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Solver function that runs the aerodynamic analysis using Q3D
%
% Input: X, visc, flightCondition constants
% Output: aeroResults

function [aeroResults] = aeroSolver(X, visc, flightCondition)
%% Load constants
Constants.m;

%% Take apart input vector
% X(1) = b
% X(2) = Croot
% X(3) = lambda_outer
% X(4) = sweep
% X(5) - X(16) = airfoil at root
% X(17) - X(28) = airfoil at tip
% Start of surrogate variables
% X(29) - X(34)Lift distribution
% X(35) - X(40)Pitching moment distribution
% X(41) = Wing weight
% X(42) = Fuel weight

b = X(1);
cRoot = X(2);
taper = X(3);
sweep = X(4)*pi/180;

Wwing = X(41);
Wfuel = X(42);

%% Create inputs for Q3D

% Wing planform geometry

y(1) = 0;
y(2) = percentKink*0.5*b;
y(3) = 0.5*b;

x(1) = 0;
x(2) = y(2) * tan(sweep);
x(3) = y(3) * tan(sweep);

c(1) = cRoot;
c(2) = c(1) - y(2)*(tan(sweep) + tan(0.0001*pi/180));
c(3) = c2 * taper;

%                x      y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [ x(1)   y(1)  0     c(1)         0;
                 x(2)   y(2)  0     c(2)         twist(1);
                 x(3)   y(3)  0     c(3)         twist(2)];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [X(5:16);
                      X(17:28)];
                  
AC.Wing.eta = [0;percentKink;1];  % Spanwise location of the airfoil sections

AC.Visc  = visc;             % 1 for viscous analysis and 0 for inviscid

% Flight Condition
AC.Aero.V     = flightCondition.V;           % flight speed (m/s)
AC.Aero.rho   = flightCondition.rho;         % air density  (kg/m3)
AC.Aero.alt   = flightCondition.alt;         % flight altitude (m)
AC.Aero.M     = flightCondition.M;           % flight Mach number 

% Calculate Reynolds number (based on mean aerodynamic chord)
S = ((c(1)-c(2)/2)+c(2))*y(2) + ((c(3)-c(2)/2)/2)*(y(3)-y(2));
MAC = (2/3)*((c(1)*((1+(c(2)/c(1))+(c(2)/c(1))^2)/(1+(c(2)/c(1)))))+(c(2)*((1+(c(3)/c(2))+(c(3)/c(2))^2)/(1+(c(3)/c(2))))));
AC.Aero.Re    = AC.Aero.V * MAC / (1.460*10^(-5));        % reynolds number 

% Calculate the required lift coefficient
MTOW = (Wconst + Wwing + Wfuel)*g;
AC.Aero.CL = (2*MTOW)/(AC.Aero.rho * AC.Aero.V^2 * S); % lift coefficient - comment this line to run the code for given alpha%      
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

%% Run Q3D and pass back results

aeroResults = Q3D_solver(AC);


end