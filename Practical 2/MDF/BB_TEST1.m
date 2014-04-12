%This is the function corresponding to Discipline System 1

%Y = [y1 y2 J]  % Updated in this function
%X = [x1 x2 x3] % Held fixed

function [Y,G] = BB_TEST1(X,Y)
    
    Y(1) = X(1)^2 + X(2) + X(3) - 0.2*Y(2);  %update y1 in Y as function of input Y and X vectors
    
return





