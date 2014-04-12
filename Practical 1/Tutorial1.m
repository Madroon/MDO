%   Tutorial1.m
%
%   Matlab file for the first tutorial

%% Clear workspace
clear;
close all;
clc;

%% Define function and constraints

% 
Au = [10 2 300 2 -5];         %upper-surface Bernstein coefficients
Al = [5 30 -2 -3 -1];    %lower surface Bernstein coefficients
A0 = [Au Al];

% Set the options for the optimisation
options = optimset('LargeScale','off');
options = optimset(options,'Display','iter');
%options = optimset(options,'TolFun', 10e-10);

% Optimise fit
[Aop, fval, exitflag, output] = fminunc(@myfun,A0,options);

%% Plotting

% Load airfoil
load('e553.mat');

% points for evaluation along x-axis
X = airfoil(:,1);      

% Take apart A
Au = Aop(1:5);
Al = Aop(6:10);

% Evaluate CST thingamajig
[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Au,Al,X);

hold on
plot(airfoil(:,1),airfoil(:,2),'g'); %plot airfoil
plot(Xtu(:,1),Xtu(:,2),'bx');    %plot upper surface coords
plot(Xtl(:,1),Xtl(:,2),'bx');    %plot lower surface coords
%plot(X,C,'r');                  %plot class function
axis([0,1,-1.5,1.5]);
