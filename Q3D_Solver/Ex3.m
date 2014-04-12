%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Quasi-3D aerodynamic solver      
%
%       A. Elham, J. Mariens
%        
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% OUTPUT DESCRIPTION:

% Res.Alpha   = Wing angle of attack
% Res.CLwing  = Total wing lift coefficient
% Res.CDwing  = Total wing drag coefficient
% Res.Wing.aero.Flight_cond = flight conditions including angle of attack
%                             (alpha), sideslip angle (beta), Mach number (M), airspeed (V) and air
%                              density (rho)
% Res.Wing   = Spanwise distribution of aerodynamic and geometrical
%              properties of wing 
%              For example plot(Res.Wing,Yst,Res.Wing.cl) plots spanwise
%              distribution of cl
% Res.Section   = aerodynamic coefficients of 2D sections 


%%

clear all
close all
clc


%% Aerodynamic solver setting

% Wing planform geometry
x2 = 14.5*tan(deg2rad(30));
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     3.5         0;
                x2  14.5   0     1.4         0];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [0.225242145503702 0.0903287369874382 0.244569273771136 0.131304991929530 0.425326163772266 -0.241316310354497 -0.0557221259409941 -0.307102344418448 -0.216646643893171 0.407681777575137;
                      0.225242145503702 0.0903287369874382 0.244569273771136 0.131304991929530 0.425326163772266 -0.241316310354497 -0.0557221259409941 -0.307102344418448 -0.216646643893171 0.407681777575137];
                  
AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
AC.Aero.V     = 236;            % flight speed (m/s)
AC.Aero.rho   = 1.225;         % air density  (kg/m3)
AC.Aero.alt   = 11000;             % flight altitude (m)
AC.Aero.Re    = 1.7e7;        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = 0.8;           % flight Mach number 


    
    % Define the lift coefficient
    AC.Aero.CL    = 0.4;          % lift coefficient - comment this line to run the code for given alpha%
    %AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 
    
    % Run the optimizer
    Res = Q3D_solver(AC);
    
