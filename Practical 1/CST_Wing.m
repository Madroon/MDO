clear all
close all
clc

% --------------------------
% Input parameters
% --------------------------
Cr = 1;                         %Root chord
Ct = 0.2;                       %Tip chord
XLe = 0.5;                      %LE shear-offset [s_offset/s_spanwise] (~tan(Sweep_angle))
B = 3;                          %Wing semi-span
A = [0.5 0.25; 0.25 0.125];     %input matrix of Bernstein-coefficients; input vector (1 x n) to create 2D-airfoil

% ---------------------------
% Class function definition
N1 = 0.5;                               %Controls LE-behaviour
N2 = 1.0;                               %Controls TE-behaviour
C = @(N1,N2,tx)((tx.^N1).*(1-tx).^N2);  %define Class-function
% ---------------------------
% Parametrization parameters
c = [Ct-Cr, Cr+XLe, Cr, 0];
d = [0,B,0,0];

tx = 0:0.05:1;                  %x-ordinates to be evaluated
ty = 0:0.05:1;                  %y-ordinates to be evaluated

[tx,ty] = meshgrid(tx,ty);

% ---------------------------
% Retrieval of X,Y,Z points on surface
% ---------------------------

X = tx.*ty.*c(1) + ty.*c(2) + tx.*c(3)+ 1.*c(4);
Y =                ty.*d(2) + tx.*d(3) +1.*d(4);
S = bernstein_2D(A,tx,ty);      %define Shape-function in 2D
Z =  S.*C(N1,N2,tx);            %multiply Shape-function with Class-function (chordwise-direction)

% ---------------------------
% Plot
% ---------------------------
figure(1)
mesh(X,Y,Z);axis equal; xlabel('X'); ylabel('Y'); zlabel('Z')
figure(2)
mesh(tx,ty,Z);
