function [BASE,L_hat_demand, L_hat_supply, sL, sy, x0, x1, iter_cnt] = WAGE(BASE, params)
% Basically, WAGE needs the same input as SOLVER + some more 

% Define tolerance for stopping 
tolerance = 0.01;

% Use SOLVER on initial guesses of L y
[BASE,L_hat_demand,L_hat_supply, sL, sy, x0, x1] = SOLVER(BASE, params);

% Define objective function: add miniscule sum in case it is 0 
% percentage difference between demand and supply 
obj_int = abs((L_hat_demand + 0.0001) / (L_hat_supply + 0.0001) - 1);

iter_cnt = 0; 

if iter_cnt == 0 && obj_int < 1e-6 % 1e-6 is basically 0, used bc. of floating point precision
    obj_int = tolerance + 0.2;
end 

while obj_int > tolerance
    % Find wage adjust factor 
    if L_hat_supply == 0.0000 
        y_factor = 1.2; % No demand -> wage up 20%

    elseif L_hat_demand == 0.000 
        y_factor = 0.8; % No supply -> wage down 20% 

    else 
        y_factor = (L_hat_demand ./ L_hat_supply) .^0.01;

    end

    % new wage 
    BASE.y = 0.5 .* BASE.y + 0.5 .* BASE.y .* y_factor; 

    % Solve model with new y 
    [BASE,L_hat_demand,L_hat_supply, sL, sy, x0, x1] = SOLVER(BASE, params);
    
    % Print the value of the objective function for this run
    disp(obj_int);
    % Update objective function
    obj_int = abs((L_hat_demand + 0.0001) / (L_hat_supply + 0.0001) - 1);

    iter_cnt = iter_cnt + 1;
end