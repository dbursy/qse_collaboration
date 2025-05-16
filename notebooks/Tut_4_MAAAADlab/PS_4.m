
%% Part a) 
% The following should simulate the test data, similar to BASE.dta

% Set up the scalars 
% Residential  Parameters

alpha_R = 0.66;
beta_R  = 0.00;
tau_R   = 0.005;	
omega_R = 0.07;
theta_R = 0.55;
c_R     = 1.3;		
a_bar_R = 1	;
S_bar_R = 20;

% Commercial parameters
alpha_C = 0.85;
beta_C  = 0.03;
tau_C   = 0.01;
omega_C = 0.03;
theta_C = 0.5;
c_C     = 1.3;
a_bar_C = 2;
S_bar_C = 20;


% Create the BASE data as a table

x = (-50:0.01:50)'; 

BASE              = table(x); 
BASE.D            = abs(x);
BASE.y            = 2.5 * ones(height(BASE), 1);
BASE.L            = 1000000 * ones(height(BASE), 1);
BASE.r_a          = 50 * ones(height(BASE), 1);
BASE.a_x_C        = NaN(height(BASE), 1);
BASE.a_x_R        = NaN(height(BASE), 1);
BASE.a_rand_C     = 1 * ones(height(BASE), 1);
BASE.a_rand_R     = 1 * ones(height(BASE), 1);
BASE.A_tilde_x_C  = NaN(height(BASE), 1);
BASE.A_tilde_x_R  = NaN(height(BASE), 1);
BASE.r_x_C        = NaN(height(BASE), 1);
BASE.r_x_R        = NaN(height(BASE), 1);
BASE.U            = NaN(height(BASE), 1);
BASE.S_star_x_C   = NaN(height(BASE), 1);
BASE.S_star_x_R   = NaN(height(BASE), 1);
BASE.S_x_C        = NaN(height(BASE), 1);
BASE.S_x_R        = NaN(height(BASE), 1);
BASE.S_x          = NaN(height(BASE), 1);
BASE.p_bar_x_C    = NaN(height(BASE), 1);
BASE.p_bar_x_R    = NaN(height(BASE), 1);
BASE.L_x_C        = NaN(height(BASE), 1);
BASE.f_bar_x_R    = NaN(height(BASE), 1);
BASE.n_x          = NaN(height(BASE), 1);
BASE.URBAN        = NaN(height(BASE), 1);
BASE.COM          = NaN(height(BASE), 1);
BASE.SHADE        = NaN(height(BASE), 1);
BASE.SHADEU       = NaN(height(BASE), 1);


% openvar("BASE")

%%%%%% End of BASE creation 


%% Test area 
params = struct( ...
    'a_bar_C', a_bar_C, 'a_bar_R', a_bar_R, ...
    'beta_C', beta_C, 'beta_R', beta_R, ...
    'tau_C', tau_C, 'tau_R', tau_R, ...
    'alpha_C', alpha_C, 'alpha_R', alpha_R, ...
    'omega_C', omega_C, 'omega_R', omega_R, ...
    'c_C', c_C, 'c_R', c_R, ...
    'theta_C', theta_C, 'theta_R', theta_R, ...
    'S_bar_C', S_bar_C, 'S_bar_R', S_bar_R ...
);





% [BASE,L_hat_demand, L_hat_supply, sL, sy, x0, x1] = SOLVER(BASE, params);

% [BASE,L_hat_demand, L_hat_supply, sL, sy, x0, x1, iter_cnt] = WAGE(BASE, params);




[BASE,L_hat_demand, L_hat_supply, sL, sy, x0, x1, obj_lab_table] = FINDEQ(BASE, params);

 openvar("BASE");


%% Plotting 

thisFolder = pwd;
disp(thisFolder)

GHEIGHT(BASE);
saveas(gcf, fullfile(thisFolder, 'GHEIGHT_whl.png'));


GBIDRENT(BASE);
saveas(gcf, 'GBIDRENT_whl.png');

GLANDRENT(BASE);
saveas(gcf, 'GLANDRENT_whl.png');










