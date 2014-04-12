clc;
close all;
clear all;

% Input parameters for geometry
g = 9.816;
MTOW = 20820;
ZFW = 18600;
n_max = 2.5;
S = 70;
b = 28;
nPlanform = 2;
nAirfoil = 2;
airfoil = 'e553.dat';
Croot = 3.5;
taper = 0.25;
Ctip = Croot * taper;
LEsweep = degtorad(5);
FSpos = 20;
RSpos = 80;
fuelTankPos = [0.1 0.7];
nEngines = 2;
EngPos = 0.25;
EngWeight = 1200;
mat.E = 7.1e10;
mat.Rho = 2800;
mat.Ft = 4.8e8;
mat.Fc = 4.6e8;
struc.Eff = 0.96;
struc.ribPitch = 0.5;


% Writer for init file
fid = fopen('test.init', 'wt');
fprintf(fid, '%g %g\n', MTOW, ZFW);
fprintf(fid, '%g \n', n_max);
fprintf(fid, '%g %g %g %g \n', S, b, nPlanform, nAirfoil);
fprintf(fid, '%g %s \n', 0, airfoil);
fprintf(fid, '%g %s \n', 1, airfoil);
fprintf(fid, '%g %g %g %g %g %g \n', Croot, 0,0,0,FSpos, RSpos);
fprintf(fid, '%g %g %g %g %g %g \n', Ctip, (0.5*b*tan(LEsweep)),(0.5*b),0,FSpos, RSpos);
fprintf(fid, '%g %g \n', fuelTankPos(1), fuelTankPos(2));
fprintf(fid, '%g \n', (nEngines/2));
fprintf(fid, '%g %g \n', EngPos, EngWeight);
fprintf(fid, '%g %g %g %g \n', mat.E, mat.Rho, mat.Ft, mat.Fc);
fprintf(fid, '%g %g %g %g \n', mat.E, mat.Rho, mat.Ft, mat.Fc);
fprintf(fid, '%g %g %g %g \n', mat.E, mat.Rho, mat.Ft, mat.Fc);
fprintf(fid, '%g %g %g %g \n', mat.E, mat.Rho, mat.Ft, mat.Fc);
fprintf(fid, '%g %g \n', struc.Eff, struc.ribPitch);
fprintf(fid, '%g \n', 0);
fclose(fid);

% Aerodynamic solver settings

% Wing planform geometry
x2 = (0.5*b*tan(LEsweep));
y2 = (0.5*b);
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     Croot         0;
                x2  y2   0     Ctip         0];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
                      0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797];
            
AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 0;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
AC.Aero.V     = 170;            % flight speed (m/s)
AC.Aero.rho   = 0.5505;         % air density  (kg/m3)
AC.Aero.alt   = 6000;             % flight altitude (m)
AC.Aero.Re    = 1.64e7;        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = 0.55;           % flight Mach number 

% Calculate CL
AC.Aero.CL = (2*MTOW*g)/(AC.Aero.rho*(AC.Aero.V^2)*n_max);

% Define the lift coefficient
%AC.Aero.CL    = 0.4;          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl

% Run the optimizer
Res = Q3D_solver(AC);
    


