% The function below serves as the non-linear constraint function that is handed to the
% optimizer in the example numerical problem. Note that this file pertains
% to the IDF-scheme

% Xi = [x1 x2 x3 y1* y2* J*]
% G = [g1 g2 g3]
% Geq = [geq1 geq2 geq3]

function [G,Geq] = Constraints(Xi)

% Retrieve values
X = Xi(1:3);      % Design variables
Ys = Xi(4:6);     % Surrogate variables

% Equality/Inequality constraints
[Y] = BB_TEST1(X,Ys);   % update y1; evaluate all constraints dependant on y1
G(1) = (1 - Y(1)/3.16); % externaly provided constraint
Geq(1) = Y(1)- Ys(1);   % constraint for consistency of y1*

[Y] = BB_TEST2(X,Ys);   % update y2; evaluate all constraints dependant on y2
G(2) = Y(2)/24 - 1;     % externaly provided constraint
Geq(2) = Y(2)- Ys(2);   % constraint for consistency of y2*

[Y] = BB_TEST3(X,Ys);   % update J; evaluate consistency of surrogate J* with actual J
Geq(3) = Y(3)- Ys(3);   % constraint for consistency of J*

return