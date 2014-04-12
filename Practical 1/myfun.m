function F = myfun(A)

%% Prelim

% Take apart A
Au = A(1:5);
Al = A(6:10);

%% Upper airfoil

% load airfoil
load('e553upper.mat');

% points for evaluation along x-axis
X = airfoil(:,1);      

% Evaluate CST thingamajig
[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Au,Al,X);

% The actual function
Y_ref = airfoil(:,2);
Y_calc = Xtl(:,2);
F = sum((Y_calc - Y_ref).^2);

%% Lower airfoil
load('e553lower.mat');

% points for evaluation along x-axis
X = airfoil(:,1);      

% Evaluate CST thingamajig
[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Au,Al,X);

% The actual function
Y_ref = airfoil(:,2);
Y_calc = Xtu(:,2);
F = F + sum((Y_calc - Y_ref).^2);