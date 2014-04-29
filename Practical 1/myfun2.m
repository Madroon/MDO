function F = myfun2(A)

%% Prelim

% load airfoil
load('withcomb.mat');

% Take apart A
Au = A(1:6);
Al = A(7:12);

%% Upper airfoil

% points for evaluation along x-axis
X = airfoilUpper(:,1);      

% Evaluate CST thingamajig
[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Au,Al,X);

% The actual function
Y_ref = airfoilUpper(:,2);
Y_calc = Xtu(:,2);
F = sum((Y_calc - Y_ref).^2);

%% Lower airfoil

% points for evaluation along x-axis
X = airfoilLower(:,1);      

% Evaluate CST thingamajig
[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Au,Al,X);

% The actual function
Y_ref = airfoilLower(:,2);
Y_calc = Xtl(:,2);
F = F + sum((Y_calc - Y_ref).^2);