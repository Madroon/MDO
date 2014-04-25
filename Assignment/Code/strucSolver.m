% strucSolver
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Solver function that runs the structural analysis using EMWET
%
% Input: X, constants
% Output: strucResults

function [Wwing] = strucSolver(X)
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
MTOW = Wconst + Wwing + Wfuel;
ZFW = Wconst + Wwing;

ArootUpper = X(5:10);
ArootLower = X(11:16);
AtipUpper = X(17:22);
AtipLower = X(23:28);
airfoilPoints = linspace(0,1,200);

load.LPoints = X(29:34);
load.TPoints = X(35:40);
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

S = ((c(1)-c(2)/2)+c(2))*y(2) + ((c(3)-c(2)/2)/2)*(y(3)-y(2));

% generate .dat file for the root airfoil

[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(ArootUpper,ArootLower,airfoilPoints);
filename = 'rootFoil';
fid = fopen([filename '.dat'], 'wt'); 
for i = 1:length(XTU)
    fprintf(fid, '%g %g\n', Xtu(i,1),Xtu(i,2));
end
for i = 1:length(XTl)
    fprintf(fid, '%g %g\n', Xtl(i,1),Xtl(i,2));
end

% generate .dat file for the tip airfoil

[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(AtipUpper,AtipLower,airfoilPoints);
filename = 'tipFoil';
fid = fopen([filename '.dat'], 'wt'); 
for i = 1:length(XTU)
    fprintf(fid, '%g %g\n', Xtu(i,1),Xtu(i,2));
end
for i = 1:length(XTl)
    fprintf(fid, '%g %g\n', Xtl(i,1),Xtl(i,2));
end


%% creating init file
% open file
filename = 'structure';
fid = fopen([filename '.init'], 'wt');   

% Weight data
fprintf(fid,'%g %g\n',MTOW,ZFW);  %MTOW and ZFW
fprintf(fid,'%g\n',n_max);

% Planform
fprintf(fid,'%g %g %g %g\n',S,b,3,2);

% Airfoils used
airfoilPosition = [0 1];
airfoilName = {'rootFoil' 'tipFoil'};

for i=1:3
    fprintf(fid,'%g %s\n',airfoilPosition(i),airfoilName{i});
end

% Section information
% note the fixed locations of the front and rear spars
for i=1:3
   fprintf(fid,'%g %g %g %g %g %g\n',c(i),x(i),y(i),0,0.15,0.7); 
end

% Fuel tank location
% also set to constant
fprintf(fid,'%g %g\n',0.1,0.85);

% Engine data
fprintf(fid,'%g\n',PP.WingEngineNumber);

for i = 1:PP.WingEngineNumber
    fprintf(fid,'%g %g\n',PP.EnginePosition(i),PP.EngineWeight(i));
end

% Materials used
fprintf(fid,'%g %g %g %g\n',Material.Wing.UpperPanel.E,Material.Wing.UpperPanel.rho,Material.Wing.UpperPanel.Sigma_tensile,Material.Wing.UpperPanel.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',Material.Wing.LowerPanel.E,Material.Wing.LowerPanel.rho,Material.Wing.LowerPanel.Sigma_tensile,Material.Wing.LowerPanel.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',Material.Wing.FrontSpar.E,Material.Wing.FrontSpar.rho,Material.Wing.FrontSpar.Sigma_tensile,Material.Wing.FrontSpar.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',Material.Wing.RearSpar.E,Material.Wing.RearSpar.rho,Material.Wing.RearSpar.Sigma_tensile,Material.Wing.RearSpar.Sigma_compressive);

% Types of stringers used
% panel efficiency and rib pitch
fprintf(fid,'%g %g\n',0.96,0.5);

% Display option - 0 don't display on screen, 1 do display
fprintf(fid,'%g\n',0);

% Close the file
fclose(fid);

%% creating load file

load.Y = linspace(0,1,14);
load.ycontrolpoints = linspace(0,1,6);

load.L = BezierCurve(length(load.Y), [load.ycontrolpoints' load.LPoints']);
load.T = BezierCurve(length(load.Y), [load.ycontrolpoints' load.TPoints']);

fid = fopen([filename '.load'], 'wt');  

for i=1:length(AS.Y)
    fprintf(fid,'%g %g %g\n',load.Y(i),load.L(i),load.T(i));
end

fclose(fid);

%% Runing EMWET

EMWET test

%% reading output

fid     = fopen('test.weight', 'r');
OUT = textscan(fid, '%s'); 
fclose(fid);

%% Pass back results
out = OUT{1};
Wwing = str2double (out(4));

end