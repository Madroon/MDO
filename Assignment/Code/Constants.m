% Constants
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Constants to be used in the calculations
%
% Input: 
% Output: 

%% Planform geometry
percentKink = 0.1; % Position of kink relative to wingspan [%]
twist(1) = 0;    % Linear twist on inner section of the wing [deg]
twist(2) = 0;    % Linear twist on outer section of the wing [deg]

%% Flight condition
V     = 170;            % flight speed (m/s)
rho   = 0.5505;         % air density  (kg/m3)
alt   = 6000;             % flight altitude (m)
M     = 0.55;           % flight Mach number
n_max = 2.5;            % Maximum load factor

%% Structural calculations constants