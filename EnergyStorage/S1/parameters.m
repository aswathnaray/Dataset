% Energy storage device parameters
params.beta_c = 1;
params.beta_d = 1;
params.gamma_c = 5;
params.gamma_d = 5;
params.R_max = 30;
params.R_min = 0;

% Time horizon
params.T = 25;

% Upper and lower bounds of P, E, D processes
params.P_max = 70;
params.P_min = 30;
params.E_max = 7;
params.E_min = 1;
params.D_min = 0;
params.D_max = 7;

% Discretization level (NOTE: optimal policy will not work if changed)
params.delta = 1;

% Price process parameters -- see possible_next_exo.m
params.P_proc.type = 'mc_jump'; % or 'mc' or 'mc_jump'
params.P_proc.mu_P = 0;
params.P_proc.sigma_P = 2.5;

% Renewable process parameters -- see possible_next_exo.m
params.E_proc.noise_type = 'uniform'; % or 'normal' 
params.E_proc.u_a = -1;
params.E_proc.u_b = 1;

% Demand process parameters -- see possible_next_exo.m
params.D_proc.type = 'sinusoidal';
params.D_proc.mu_D = 0;
params.D_proc.sigma_D = 2;

% MDP Parameters
params.initial_state = [params.R_min,params.E_min,params.P_min,params.D_min];
params.feasible_set = @(s,t)(feasible_set(s,t,params));
params.use_next_exo = 1;
params.contribution = @(s,a,t)(contribution(s,a,t,params));
params.possible_next_states = -1; % use transition function formulation, not transition probability formulation
params.possible_next_exo = @(s,a,t)(possible_next_exo(s,a,t,params));
params.transition = @(s,a,t,w)(transition(s,a,t,w,params));

% Optimal Policy
S = load('bdp_A.mat');
params.optimal_policy = @(s,t)(optimal_policy(S.A,s,t,params));