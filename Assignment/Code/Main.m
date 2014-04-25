% MAIN PROGRAM
% MDO assignment
% Nick Noordam - 1507486
% 
%% Clear workspace
clc;
close all;
clear all;

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
lb(1) = 0.5; ub(1) = 1.5;           % b - span
lb(2) = 0.5; ub(2) = 1.5;           % Croot
lb(3) = 0.5; ub(3) = 1.5;           % Taper
lb(4) = 0.5; ub(4) = 1.5;           % Sweep angle
% - - - - - - - - - - - - - - - - - - Airfoils
lb( 5:16) = 0.5; ub( 5:16) = 1.5;   % Airfoil at root
lb(17:28) = 0.5; ub(17:28) = 1.5;   % Airfoil at tip
% - - - - - - - - - - - - - - - - - - Surrogate variables
lb(29:34) = 0.5; ub(29:34) = 1.5;   % Lift distribution
lb(35:40) = 0.5; ub(35:40) = 1.5;   % Pitching moment distribution
lb(41) = 0.5; ub(41) = 1.5;         % Wing weight star
lb(42) = 0.5; ub(42) = 1.5;         % Fuel weight star

%% Set up the options
options = optimset('Display','iter');
options = optimset(options,'Algorithm', 'interior-point');
options = optimset(options,'DiffMinChange', 0.1);
options = optimset(options,'TolFun',1e-4);

%% Run the optimizer
[X,fval,exitflag,output, lambda] = fmincon(@Solver,X0,[],[],[],[],lb,ub,@Constraints,options);

%% Plot the results
