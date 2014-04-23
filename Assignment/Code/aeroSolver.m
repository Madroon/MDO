% aeroSolver
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Solver function that runs the aerodynamic analysis using Q3D
%
% Input: X, visc, constants
% Output: aeroResults

function [aeroResults] = aeroSolver(X, visc)
%% Load constants

Constants.m;

%% Create inputs for Q3D

% Wing planform geometry

y1 = 0;
y2 = percentKink*0.5*X(1);
y3 = 0.5*X(1);

x1 = 0;
x2 = X(2) * (1 - X(3));
x3 = x2 + (y3-y2)*tan(X(5));

c1 = X(2);
c2 = c1 * X(3);
c3 = c2 * X(4);

%                x      y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [ x1     y1    0     c1         0;
                 x2     y2    0     c2         twist(1);
                 x3     y3    0     c3         twist(2)];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
                      0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797];
                  
AC.Wing.eta = [0;percentKink;1];  % Spanwise location of the airfoil sections

AC.Visc  = visc;             % 1 for viscous analysis and 0 for inviscid

% Flight Condition
AC.Aero.V     = V;            % flight speed (m/s)
AC.Aero.rho   = rho;         % air density  (kg/m3)
AC.Aero.alt   = alt;             % flight altitude (m)
AC.Aero.M     = M;           % flight Mach number 

% Calculate Reynolds number (based on mean aerodynamic chord)
AC.Aero.Re    = 1.64e7;        % reynolds number 

% Calculate the required lift coefficient
AC.Aero.CL    = 1.048;          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

%% Run Q3D and pass back results

aeroResults = Q3D_solver(AC);


end