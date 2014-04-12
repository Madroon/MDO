% The function below serves as the objective function that is handed to the
% optimizer in the example numerical problem.
% In an MDF-scheme, a coordinator-block has to be added in order to ensure
% consistency between sub-systems. For this problem, the coordinator is added here in the
% objective function

%Y = [y1 y2 J]   % Updated in this function
%X = [x1 x2 x3]  % Held fixed
%OBJ = J (after convergence of y1 and y2)

function [OBJ]= Objective(X,Y0)

% COORDINATION LOOP; ensures consistent y1 and y2 for given input X
Y = Y0; % initial search point for loop to find consistent Y
check= 0;

while check == 0    %while check==0 run convergence loop, otherwise continue
    Yin = Y;              % store input Y under separate variable name
    [Y] = BB_TEST1(X,Y);  % update value of y1
    [Y] = BB_TEST2(X,Y);  % update value of y2
    [Y] = BB_TEST3(X,Y);  % update value of J (i.e the objective)
    % (now all three entries of Y have been updated)
    
    % Please note that in this loop the objective value J is included,
    % producing the final feasible J when consistent y1 and y2 have been
    % found (all J's before that being inconsistent). This is not
    % absolutely necessary; a different approach would be to iterate only for y1
    % and y2, finding consistent y1* and y2*, and using these consistent
    % values to evaluate J just once (for this iteration in X). In terms of computation-effort this
    % last approach is preferable.
    
    dY = (Yin - Y);       % differences in Y-entries before and after iteration
    if dY*dY' <= 1e-6     % convergence tolerance; loop will run as long as the error dY*dY' is above 1e-6
        check = 1;
    end
end

% Objective value
OBJ = Y(3);                % objective J is simply the third entry of the converged Y

return