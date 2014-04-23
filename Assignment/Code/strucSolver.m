% strucSolver
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Solver function that runs the structural analysis using EMWET
%
% Input: X, constants
% Output: strucResults

function [strucResults] = strucSolver(X)
%% Load constants

Constants.m;

%% Initial calculations
% Wing planform geometry
planform.y(1) = 0;
planform.y(2) = percentKink*0.5*X(1);
planform.y(3) = 0.5*X(1);

planform.x(1) = 0;
planform.x(2) = X(2) * (1 - X(3));
planform.x(3) = planform.x(2) + (planform.y(3)-planform.y(2))*tan(X(5));

planform.c(1) = X(2);
planform.c(2) = planform.c(1) * X(3);
planform.c(3) = planform.c(2) * X(4);
Area = ((planform.c(1)-planform.c(2)/2)+planform.c(2))*planform.y(2) + ((planform.c(3)-planform.c(2)/2)/2)*(planform.y(3)-planform.y(2));

%% creating init file
% open file
filename = 'structure';
fid = fopen([filename '.init'], 'wt');   

% Weight data
fprintf(fid,'%g %g\n',X(..),X(..));  %MTOW and ZFW
fprintf(fid,'%g\n',n_max);

% Planform
fprintf(fid,'%g %g %g %g\n',Area,X(1),3,2);

% Airfoils used

% ADD .DAT FILE GENERATOR AND REWRITE THE FOR LOOP
for i=1:3
    fprintf(fid,'%g %s\n',I.Wing(1).AirfoilPosition(i),I.Wing(1).AirfoilName{i});
end

% Section information
for i=1:3
   fprintf(fid,'%g %g %g %g %g %g\n',planform.c(i),planform.x(i),planform.y(i),0,0.15,0.7); 
end

% Fuel tank location
fprintf(fid,'%g %g\n',0.1,0.7);

% Engine data
fprintf(fid,'%g\n',I.PP(1).WingEngineNumber);

for i = 1:I.PP(1).WingEngineNumber
    fprintf(fid,'%g %g\n',I.PP(i).EnginePosition,I.PP(i).EngineWeight);
end

% Materials used
fprintf(fid,'%g %g %g %g\n',I.Material.Wing.UpperPanel.E,I.Material.Wing.UpperPanel.rho,I.Material.Wing.UpperPanel.Sigma_tensile,I.Material.Wing.UpperPanel.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',I.Material.Wing.LowerPanel.E,I.Material.Wing.LowerPanel.rho,I.Material.Wing.LowerPanel.Sigma_tensile,I.Material.Wing.LowerPanel.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',I.Material.Wing.FrontSpar.E,I.Material.Wing.FrontSpar.rho,I.Material.Wing.FrontSpar.Sigma_tensile,I.Material.Wing.FrontSpar.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',I.Material.Wing.RearSpar.E,I.Material.Wing.RearSpar.rho,I.Material.Wing.RearSpar.Sigma_tensile,I.Material.Wing.RearSpar.Sigma_compressive);

% Types of stringers used
fprintf(fid,'%g %g\n',I.Structure.Wing.UpperPanelEfficiency,I.Structure.Wing.RibPitch);

% Display option
fprintf(fid,'%g\n',DisplayOption);

% Close the file
fclose(fid);

%% creating load file

fid = fopen([filename '.load'], 'wt');  

for i=1:length(AS.Y)
    fprintf(fid,'%g %g %g\n',AS.Y(i),AS.L(i),AS.T(i));
end

fclose(fid);

%% Runing EMWET

EMWET test

%% reading output

fid     = fopen('test.weight', 'r');
OUT = textscan(fid, '%s'); 
fclose(fid);

out = OUT{1};
Wwing = str2double (out(4));



end