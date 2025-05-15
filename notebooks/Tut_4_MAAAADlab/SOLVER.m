function [BASE_updated, L_hat_demand,L_hat_supply, sL, sy, x0, x1]= SOLVER(BASE, params)
% Solver that computes all endogenous variables, including aggregate labour demand and supply	 
%

% Unpac parameters
a_bar_C = params.a_bar_C; a_bar_R = params.a_bar_R;
beta_C = params.beta_C; beta_R = params.beta_R;
tau_C = params.tau_C; tau_R = params.tau_R;
alpha_C = params.alpha_C; alpha_R = params.alpha_R;
omega_C = params.omega_C; omega_R = params.omega_R;
c_C = params.c_C; c_R = params.c_R;
theta_C = params.theta_C; theta_R = params.theta_R;
S_bar_C = params.S_bar_C; S_bar_R = params.S_bar_R;


% Clean pre-existing values
    columnsToClean = {'A_tilde_x_C', 'A_tilde_x_R', 'a_x_C', 'a_x_R', ...
                        'r_x_C', 'r_x_R', 'U', 'S_x_C', 'S_x_R', 'p_bar_x_C', ...
                        'p_bar_x_R', 'L_x_C', 'f_bar_x_R', 'n_x','URBAN','COM','S_star_x_C','S_star_x_R'};
    for i = 1:length(columnsToClean)
        columnName = columnsToClean{i};
        if ismember(columnName, BASE.Properties.VariableNames)
            BASE.(columnName) = NaN(height(BASE), 1);  % Replace with NaN
        else
            warning('Column "%s" does not exist in the table.', columnName);
        end
    end

   % Compute Amenity and floor space shifters
    BASE.A_tilde_x_C = a_bar_C .* BASE.a_rand_C .* exp(-tau_C .* BASE.D) .* BASE.L .^ beta_C;
    BASE.A_tilde_x_R = a_bar_R .* BASE.a_rand_R .* exp(-tau_R .* BASE.D) .* BASE.L .^ beta_R;
    BASE.a_x_C = BASE.A_tilde_x_C .^ (1 / (1 - alpha_C)) .* BASE.y .^ (alpha_C / (alpha_C - 1));
    BASE.a_x_R = BASE.A_tilde_x_R .^ (1 / (1 - alpha_R)) .* BASE.y .^ (1 / (1 - alpha_R));

   % Compute Land rent ------- in line 2 other approach uses omega instead
   % of theta_C?? but in stata it is also theta??
    BASE.r_x_C = BASE.a_x_C ./ (1 + omega_C) .* ...
        (BASE.a_x_C ./ (c_C * (1 + theta_C))) .^ ((1 + omega_C) / (theta_C - omega_C)) ...
        - c_C .* (BASE.a_x_C ./ (c_C * (1 + theta_C))) .^ ((1 + theta_C) / (theta_C - omega_C));

    BASE.r_x_R = BASE.a_x_R ./ (1 + omega_R) .* ...
        (BASE.a_x_R ./ (c_R * (1 + theta_R))) .^ ((1 + omega_R) / (theta_R - omega_R)) ...
        - c_R .* (BASE.a_x_R ./ (c_R * (1 + theta_R))) .^ ((1 + theta_R) / (theta_R - omega_R));

    % Define Land use 

    BASE.U(BASE.r_a > BASE.r_x_C & BASE.r_a > BASE.r_x_R) = 3; 
    BASE.U(BASE.r_x_R > BASE.r_x_C & BASE.r_x_R > BASE.r_a) = 2; 
    BASE.U(BASE.r_x_C > BASE.r_x_R & BASE.r_x_C > BASE.r_a) = 1;

    % Edge of residential zone
    x1 = min(BASE.x(BASE.U == 3 & BASE.x >= 0));
    x0 = min(BASE.x(BASE.U ~= 1 & BASE.x > 0));

    % Profit maximizing height
    BASE.S_star_x_C(BASE.U == 1) = ( BASE.a_x_C(BASE.U == 1) ./ (c_C*(1+theta_C)))  .^(1./(theta_C - omega_C)) ;
    BASE.S_star_x_R(BASE.U == 2) = ( BASE.a_x_R(BASE.U == 2) ./ (c_R*(1+theta_R)))  .^(1./(theta_R - omega_R)) ;

    % Compute actual height 
    % Sbar is input into FINDEQ function, currently workaround implemented
    % by defining it as scalar but will need to switch it out. 
    BASE.S_x_C(BASE.U == 1) = min(S_bar_C, BASE.S_star_x_C(BASE.U == 1));
    BASE.S_x_R(BASE.U == 2) = min(S_bar_R, BASE.S_star_x_R(BASE.U == 2)); 
    
    % Compute bid rents 
    BASE.p_bar_x_C(BASE.U == 1) = BASE.a_x_C(BASE.U == 1) .* 1./(1-omega_C) .* BASE.S_x_C(BASE.U == 1) .^ omega_C;
    BASE.p_bar_x_R(BASE.U == 2) = BASE.a_x_R(BASE.U == 2) .* 1./(1-omega_R) .* BASE.S_x_R(BASE.U == 2) .^ omega_R;

    % Compute labor demand 
    BASE.L_x_C(BASE.U == 1) = alpha_C ./ (1-alpha_C) .* BASE.p_bar_x_C(BASE.U == 1) ./ BASE.y(BASE.U == 1) .* BASE.S_x_C(BASE.U == 1);
    L_hat_demand = sum(BASE.L_x_C, 'omitnan');

    % Compute labor supply 
    BASE.f_bar_x_R(BASE.U == 2) = (1-alpha_R) ./ BASE.p_bar_x_R(BASE.U == 2) .* BASE.y(BASE.U == 2);
    BASE.n_x = BASE.S_x_R ./ BASE.f_bar_x_R; 
    L_hat_supply = sum(BASE.n_x, 'omitnan');

    % Save some final stats
    sL = mean(BASE.L, 'omitnan');
    sy = mean(BASE.y, 'omitnan');
    BASE.S_x = max(BASE.S_x_C, BASE.S_x_R);

    % Code Land use 
    BASE.URBAN(BASE.U < 3) = 1;
    BASE.COM(BASE.U == 1) = 1;
    
    BASE_updated = BASE;
end