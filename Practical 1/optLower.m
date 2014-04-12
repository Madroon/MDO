function F = optLower(A)

% load airfoil
load('e553lower.mat');

% points for evaluation along x-axis
X = airfoil(:,1);      

% Take apart A
Au = A(1:5);
Al = A(6:10);

% Evaluate CST thingamajig
[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Au,Al,X);

% The actual function
Y_ref = airfoil(:,2);
Y_calc = [Xtu(:,2); Xtl(:,2)];
F = sum((Y_calc - Y_ref).^2);
