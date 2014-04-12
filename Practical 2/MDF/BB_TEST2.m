%This is the function corresponding to Discipline System 2

%Y = [y1 y2 J]  % Updated in this function
%X = [x1 x2 x3] % Held fixed

function [Y,G] = BB_TEST2(X,Y)
    
    Y(2) = (sqrt(Y(1)) + X(1) + X(3)); %update y2 in Y as function of input Y and X vectors
    
return





