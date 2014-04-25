% Constants
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Constants to be used in the calculations
%
% Input: 
% Output: 

%% Initial design point

I(1) =                   % b
I(2) =                   % Croot
I(3) =                   % lambda_outer
I(4) =                   % Sweep
I(5:16)  =                  % airfoil at root
I(17:28) =                  % airfoil at tip

%Start of surrogate variables

I(29:34) =              % Lift distribution
I(35:40) =              % Pitching moment distribution
I(41) =                 % Wing weight star
I(42) =                 % Fuel weight star

%% Basic constants
g = 9.816;

%% Planform geometry constants
percentKink = 0.1; % Position of kink relative to wingspan [%]
twist(1) = 0;    % Linear twist on inner section of the wing [deg]
twist(2) = 0;    % Linear twist on outer section of the wing [deg]

%% Weight constants
Wconst = 10;            % Weight of the aircraft minus wing and fuel

%% Flight condition - cruise
V     = 170;            % flight speed (m/s)
rho   = 0.5505;         % air density  (kg/m3)
alt   = 6000;           % flight altitude (m)
M     = 0.55;           % flight Mach number

%% Flight condition - max load
n_max = 2.5;            % Maximum load factor

%% Structural calculations constants
Material.Wing.UpperPanel.E = 7.1e10;
Material.Wing.UpperPanel.rho =2800;
Material.Wing.UpperPanel.Sigma_tensile = 4.8e8;
Material.Wing.UpperPanel.Sigma_compressive = 4.6e8;

Material.Wing.LowerPanel.E = 7.1e10;
Material.Wing.LowerPanel.rho = 2800;
Material.Wing.LowerPanel.Sigma_tensile = 4.8e8;
Material.Wing.LowerPanel.Sigma_compressive = 4.6e8;

Material.Wing.FrontSpar.E = 7.1e10;
Material.Wing.FrontSpar.rho = 2800;
Material.Wing.FrontSpar.Sigma_tensile = 4.8e8;
Material.Wing.FrontSpar.Sigma_compressive = 4.6e8;

Material.Wing.RearSpar.E = 7.1e10;
Material.Wing.RearSpar.rho = 2800;
Material.Wing.RearSpar.Sigma_tensile =4.8e8;
Material.Wing.RearSpar.Sigma_compressive = 4.6e8;

%% Propulsion
PP.WingEngineNumber   =   2;  
PP.EnginePosition = [0.25 0.5];
PP.EngineWeight = [1200 1200];