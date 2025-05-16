function [BASE,L_hat_demand, L_hat_supply, sL, sy, x0, x1, iter_cnt] = FINDEQ(BASE, params)
% Find the Equilibrium 

% Run Solver once on clean Base data 
[BASE,L_hat_demand,L_hat_supply, sL, sy, x0, x1] = SOLVER(BASE, params);

% Define objective function for FINDEQ (in terms of population) 
obj_lab = abs( (sL ./ (0.5 .* (L_hat_supply + L_hat_demand))) -1); 

while obj_lab > 0.01 

    % This I would just do bc. stata also does it, from my Understanding can
    % delete this
    [BASE,L_hat_demand,L_hat_supply, sL, sy, x0, x1] = SOLVER(BASE, params);

    [BASE,L_hat_demand, L_hat_supply, sL, sy, x0, x1, iter_cnt] =    WAGE(BASE, params);


    % City Sanity check 
    if L_hat_demand + L_hat_supply == 0
        error('Error: City does not reach critical size. Increase productivity to make city more attractive.');
    end
    
    % Update the objective function
    obj_lab = abs( (sL ./ (0.5 .* (L_hat_supply + L_hat_demand))) -1); 
    fprintf('Current objective value (FINDEQ) is %.6f\n', obj_lab);
    % Update guess of total employment with average of old guess and
    % updated demand and supply from model 
    BASE.L = 0.5 .* BASE.L + 0.5*0.5 .* (L_hat_supply + L_hat_demand);

end