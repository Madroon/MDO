% Solver
% --------------
% MDO assignment
% Nick Noordam - 1507486
% 
% Solver function that runs the analysis on the basis of the input design
% vector.
%
% Input: X
% Output: F
%
% Design vector
% X(1) = b
% X(2) = Croot
% X(3) = lambda_outer
% X(4) = sweep
% X(5) - X(16) = airfoil at root
% X(17) - X(28) = airfoil at tip
% Start of surrogate variables
% X(29) - X(34)Lift distribution
% X(35) - X(40)Pitching moment distribution
% X(41) = Wing weight star
% X(42) = Fuel weight star


function [F] = Solver(X)
%% Calculate objective function and pass back to Main

F = (1 + X(41) + X(42))/3;

end
