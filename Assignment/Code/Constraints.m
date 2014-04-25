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
Constants.m;

%% Remove scaling
X = X .* I;

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
% X(41) = Wing weight star
% X(42) = Fuel weight star

%% Run aerodynamic solver at cruise (viscous) -> L/D
visc = 1;
flightCondition.V   = ;           % flight speed (m/s)
flightCondition.rho = ;         % air density  (kg/m3)
flightCondition.alt = ;         % flight altitude (m)
flightCondition.M   = ;           % flight Mach number 

[aeroCruiseResults] = aeroSolver(X, visc, flightCondition);

%% Run aerodynamic solver at max load (inviscid) -> lift + pitch distribution
visc = 0;
flightCondition.V   = ;           % flight speed (m/s)
flightCondition.rho = ;          % air density  (kg/m3)
flightCondition.alt = ;         % flight altitude (m)
flightCondition.M   = ;           % flight Mach number 

[aeroMaxLoadResults] = aeroSolver(X, visc, flightCondition);
load.L = aeroMaxLoadResults.Wing.ccl;
load.T = aeroMaxLoadResults.Wing.cm_c4;

% Calculate lift and pitch moment distribution from Bezier curves
load.LPoints = X(29:34);
load.TPoints = X(35:40);
load.Y = linspace(0,1,14);
load.ycontrolpoints = linspace(0,1,6);

load.Lstar = BezierCurve(length(load.Y), [load.ycontrolpoints' load.LPoints']);
load.Tstar = BezierCurve(length(load.Y), [load.ycontrolpoints' load.TPoints']);

%% Run structural solver -> Wstr,wing

[Wwing] = strucSolver(X);

%% Calculate performance characteristics -> Wfuel


%% Equality constraints
%
% Surrogate values checking 
% Wing weight star - wing weight = 0
% Fuel weight star - fuel weight = 0
% sum(load.L - load.Lstar) = 0
% sum(load.L - load.Tstar) = 0


%% Inequality constraints

end
