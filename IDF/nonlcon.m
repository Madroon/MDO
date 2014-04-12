function [c, ceq] = nonlcon(X)


x1 = X(1);
x2 = X(2);
x3 = X(3);

y1s = X(4);   % surrogate value of y1
y2s = X(5);   % surrogate value of y2

c(1) = 1-y1s/3.16;  % first constraint of the original problem
c(2) = y2s/24-1;    % second constraint of the original problem

y1 = x1^2 + x2+x3 - 0.2*y2s;
y2 = sqrt(y1s)+x1+x3;

ceq(1) = y1 - y1s;  % consistency constraint for y1
ceq(2) = y2 - y2s;  % consistency constraint for y2

