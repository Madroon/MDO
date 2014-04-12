%This is the function corresponding to discipline system 3; i.e. the
%objective-function of this optimization problem.

%Y = [y1 y2 J]
%X = [x1 x2 x3]

function [Y,G] = BB_TEST3(X,Y)
    
    Y(3) = X(2)^2 + X(3) + Y(1)  + exp(-Y(2));
    
return

%note that while the complete vectors X and Y are used as input, only the
%third entry in Y (i.e. J) is updated by this function.