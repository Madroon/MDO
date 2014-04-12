% Main file to demonstrate Individual Discipline Feasible method
clear all
close all
clc

% Initial vector for the design variables [X]
X0 = [1,5,2,4,10,0];
LB = [-10, 0, 0,-inf,-inf,-inf];
UB = [ 10,10,10,inf,inf,inf];

% Options for the optimization
options = optimset('Display','iter','Algorithm','active-set');

% Optimization function
[X,Obj] = fmincon(@(x) Objective(x),X0,[],[],[],[],LB,UB,@(x) Constraints(x),options)