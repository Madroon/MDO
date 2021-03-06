% MAIN PROGRAM
% MDO assignment
% Nick Noordam - 1507486
% 
%% Clear workspace
clc;
close all;
clear all;

%% Load constants
Constants;

%% Set up for the optimizer
% Design vector
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

X0 = ones(42,1);

%% Bounds of the problem
% - - - - - - - - - - - - - - - - - - Planform variables
lb(1) = 20; ub(1) = 40;           % b - span
lb(2) = 5; ub(2) = 15;           % Croot
lb(3) = 0.1; ub(3) = 1.0;           % Taper
lb(4) = 10; ub(4) = 45;           % Sweep angle
% - - - - - - - - - - - - - - - - - - Airfoils
lb( 5:16) = -1.0; ub( 5:16) = 1.1;   % Airfoil at root
lb(17:28) = -1.0; ub(17:28) = 1.1;   % Airfoil at tip
% - - - - - - - - - - - - - - - - - - Surrogate variables
lb(29:34) = 1e4; ub(29:34) = 10e4;   % Lift distribution
lb(35:40) = -1e4; ub(35:40) = -16e4;   % Pitching moment distribution
lb(41) = 1e4; ub(41) = 3e4;         % Wing weight star
lb(42) = 1e5; ub(42) = 4e5;         % Fuel weight star
% - - - - - - - - - - - - - - - - - - Scale the bounds
lb = lb ./ I;
ub = ub ./ I;
lb(5:28) = lb(5:28).*I(5:28);
ub(5:28) = ub(5:28).*I(5:28);


%% Set up the options
options = optimset('Display','iter');
options = optimset(options,'Algorithm', 'sqp');
options = optimset(options,'DiffMinChange', 0.01);
options = optimset(options,'DiffMaxChange', 0.1);
options = optimset(options,'TolFun',1e-4);
options = optimset(options,'TolCon',1e-4);
options = optimset(options,'TolX',1e-4);
options = optimset(options,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotconstrviolation});


%% Run the optimizer
tic;
[X,fval,exitflag,output, lambda, grad, hessian] = fmincon(@Solver,X0,[],[],[],[],lb,ub,@Constraints,options);
toc;
%% Plot the results
