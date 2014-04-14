
clear all
close all
clc

filename = 'test';
DisplayOption = 1; 

%% 1. Load the input

I = Initiator;
Q3D_Start;  % make sure Q3D AeroSolver is located in the same folder as this m file

%% 2. D

%% geometry and load calculations

AS.Y = linspace(0,1,20);
q = 0.5*0.5505*170^2;   % dynamic pressure
MAC = 2/3*3.5*(1+0.25+0.25^2)/(1+0.25); % mean aerodynamic chord
AS.L = interp1(Res.Wing.Yst,Res.Wing.ccl*q,AS.Y*I.Wing(1).Span/2,'spline'); %lift distribution
AS.T = interp1(Res.Wing.Yst,Res.Wing.cm_c4.*Res.Wing.chord*q*MAC,AS.Y*I.Wing(1).Span/2,'spline'); % pitching moment distribution

%% creating init file

fid = fopen([filename '.init'], 'wt');   
fprintf(fid,'%g %g\n',I.Weight.MTOW,I.Weight.ZFW);
fprintf(fid,'%g\n',I.n_max);
fprintf(fid,'%g %g %g %g\n',I.Wing(1).Area,I.Wing(1).Span,I.Wing(1).SectionNumber,I.Wing(1).AirfoilNumber);

for i=1:length(I.Wing(1).AirfoilName)
    fprintf(fid,'%g %s\n',I.Wing(1).AirfoilPosition(i),I.Wing(1).AirfoilName{i});
end

for i=1:I.Wing(1).SectionNumber
   fprintf(fid,'%g %g %g %g %g %g\n',I.Wing(i).WingSection.Chord,I.Wing(i).WingSection.Xle,I.Wing(i).WingSection.Yle,I.Wing(i).WingSection.Zle,I.Wing(i).WingSection.FrontSparPosition,I.Wing(i).WingSection.RearSparPosition); 
end

fprintf(fid,'%g %g\n',I.WingFuelTank.Ystart,I.WingFuelTank.Yend);
fprintf(fid,'%g\n',I.PP(1).WingEngineNumber);

for i = 1:I.PP(1).WingEngineNumber
    fprintf(fid,'%g %g\n',I.PP(i).EnginePosition,I.PP(i).EngineWeight);
end

fprintf(fid,'%g %g %g %g\n',I.Material.Wing.UpperPanel.E,I.Material.Wing.UpperPanel.rho,I.Material.Wing.UpperPanel.Sigma_tensile,I.Material.Wing.UpperPanel.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',I.Material.Wing.LowerPanel.E,I.Material.Wing.LowerPanel.rho,I.Material.Wing.LowerPanel.Sigma_tensile,I.Material.Wing.LowerPanel.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',I.Material.Wing.FrontSpar.E,I.Material.Wing.FrontSpar.rho,I.Material.Wing.FrontSpar.Sigma_tensile,I.Material.Wing.FrontSpar.Sigma_compressive);
fprintf(fid,'%g %g %g %g\n',I.Material.Wing.RearSpar.E,I.Material.Wing.RearSpar.rho,I.Material.Wing.RearSpar.Sigma_tensile,I.Material.Wing.RearSpar.Sigma_compressive);

fprintf(fid,'%g %g\n',I.Structure.Wing.UpperPanelEfficiency,I.Structure.Wing.RibPitch);
fprintf(fid,'%g\n',DisplayOption);

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

