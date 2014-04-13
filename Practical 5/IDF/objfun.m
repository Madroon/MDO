function J = objfun(X)

x1 = X(1);  % not needed for objfun calculation using IDF
x2 = X(2);
x3 = X(3);

y1s = X(4);   % surrogate value of y1
y2s = X(5);   % surrogate value of y2

J = x2^2 + x3 + y1s + exp(-y2s);


