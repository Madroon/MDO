% fuelTankCalc
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% function to calculate the volume of the fuel tank
%
% Input: X, constants
% Output: Vtank

function [Vtank] = fuelTankCalc(X)
%% Load constants
Constants;

%% Calculate airfoil coefficients at needed locations
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

%% Get some needed inputs from the design vector
b = X(1);
cRoot = X(2);
taper = X(3);
sweep = X(4)*pi/180;

% Planform calculations
y(1) = 0;
y(2) = percentKink*0.5*b;
y(3) = 0.5*b;

x(1) = 0;
x(2) = y(2) * tan(sweep);
x(3) = y(3) * tan(sweep);

c(1) = cRoot;
c(2) = c(1) - y(2)*(tan(sweep) + tan(0.0001*pi/180));
taperEndFueltank = (1-taper)*(0.85-percentKink);
c(3) = c(2) * taperEndFueltank;

%% Airfoils used
Aroot =  X(5:16);
Atip  =  X(17:28);

deltaA = (Aroot - Atip);

Akink = Aroot + percentKink * deltaA;
Aend  = Aroot + 0.85 * deltaA;

A(1:length(Aroot),1) = Aroot;
A(1:length(Aroot),2) = Akink;
A(1:length(Aroot),3) = Aend;

airfoilPoints = linspace(0,1,200)';
FSindex = length(airfoilPoints)*0.15;
RSindex = length(airfoilPoints)*0.7;
vertices = [];

% Vertices at the root
for i = 1:3
    [Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(A(1:6,i),A(7:12,i),airfoilPoints);
    Xtu = Xtu * c(i);
    Xtl = Xtl * c(i);
    vertices = [ vertices ;  Xtu(FSindex,1) Xtl(FSindex,2) y(i) ;  Xtu(FSindex,1) Xtu(FSindex,2) y(i) ; Xtu(RSindex,1) Xtl(RSindex,2) y(i) ; Xtu(RSindex,1) Xtu(RSindex,2) y(i)];
end

%% Calculate volume
[K,Vtank] = convhulln(vertices);
Vtank = Vtank * 2;

end