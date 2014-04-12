% Main file to demonstrate the MultiDiscipline Feasible method
clear all
close all
clc

% Initial vector for the design variables
X0 = [1,5,2];
LB = [-10, 0, 0];
UB = [ 10,10,10];

% Initial vector for the dependent variables (needed to start the coordination iteration)
Y0 = [4,10,0];

% Options for the optimization
options = optimset('Display','iter','Algorithm','active-set');

% Optimization function
[X,Obj] = fmincon(@(x) Objective(x,Y0),X0,[],[],[],[],LB,UB,@(x) Constraints(x,Y0),options)

% NB: in this example, the objective is a function of two input vectors x
% and Y0. However, by using the function handle "@(x) Objective(x,Y0)" only
% x is identified as a variable, while Y0 is held constant as a parameter.
% The same applies to the constraints function.