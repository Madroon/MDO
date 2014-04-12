% The function below serves as the objective function that is handed to the
% optimizer in the example numerical problem. Note that this file pertains
% to the IDF-scheme

% Xi = [x1 x2 x3 y1* y2* J*]
% OBJ = J (after analysis with first 5 entries of Xi)

function [OBJ]= Objective(Xi)

% Retrieve values
X = Xi(1:3);  % Design variables
Ys = Xi(4:6); % Surrogate variables

% You'll notice that the design-vector now consists of the original
% design-variables x1, x2 and x3 together with surrogate variables for
% state-variables y1 and y2 and J. Strickly, it is not necessary to include
% a surrogate for J, as it will not be used as input in the Discipline 3 function
% BB_TEST3 (please verify for yourself)


% Perform analysis
%[Y] = BB_TEST1(X,Ys);
%[Y] = BB_TEST2(X,Ys);
[Y] = BB_TEST3(X,Ys);   %update J, i.e calculate objective value for input Xi

% Objective function
OBJ = Y(3);

return