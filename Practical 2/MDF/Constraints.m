% Unfortunately, because the objective and nonlinear constraint functions
% have to be handed separately to fmincon, the system has to be iterated
% again, in order to check the overall constraints. This is inefficient, as the
% exact same iteration is performed as for the objective function (same
% input X => same consistent Y)
% This constraint function includes the exact same coordination loop as
% Objective.m, however now the constraint values G and Geq are given as
% output, as opposed to the objective J.
% Note that this file pertains to the MDF scheme

%Y = [y1 y2 J]   % Updated in this function
%X = [x1 x2 x3]  % Held fixed
%G = [g1 g2]
%Geq = []

function [G,Geq] = Constraints(X,Y0)

% COORDINATION LOOP
Y = Y0;
check= 0;

while check == 0
    Yin = Y;
    [Y] = BB_TEST1(X,Y);
    [Y] = BB_TEST2(X,Y);
    [Y] = BB_TEST3(X,Y);
    dY = (Yin - Y);
    
    if dY*dY' <= 1e-6
        check = 1;
    end
end

% Inequality constraints
G(1) = (1 - Y(1)/3.16);
G(2) = Y(2)/24 - 1;

% Equality constraints
Geq = [];
return