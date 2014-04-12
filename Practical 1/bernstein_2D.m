function [S] = bernstein_2D(Au,tx,ty)

%S = Z-value at point of interest
%Au = input matrix of Bernstein coefficients
%tx = x-stations to be evaluated
%ty = y-stations to be evaluated

    [M,N] = size(Au);
    S = zeros(size(tx));

%--------------------------------------------------------------------------
%function to calculate Shape-surface of unitary Bernstein coefficients
%multiplied by the entries of Au

    for i = 1:length(tx(1,:));
        for j = 1:length(ty(:,1));
    
            K1 = 0;
            for m = 0:M-1
                for n = 0:N-1
                    K1 = K1 + Au(m+1,n+1)*bbt(m,M-1,tx(i,j))*bbt(n,N-1,ty(i,j)); 
                end
            end
            S(i,j) = K1;
        end
    end

return

% Shape function
%--------------------------------------------------------------------------
function[b] = bbt(i,n,tx)
%function to calculate Newton binomial * Bernstein-polynomial 

%b  = output
%i  = degree of sub-polynomial under consideration
%n  = degree of polynomial under consideration
%tx = x-stations to be evaluated

if i >= 0
    if n >= 0
        if (n-i) >= 0
            b = factorial(n)/(factorial(i)*factorial(n-i)) * tx^i * (1-tx)^(n-i);
        else
            b = 0;
        end
    else
        b = 0;
    end
else
    b = 0;
end

return

