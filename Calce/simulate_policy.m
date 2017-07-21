 function [ mean_total, totals  ] = simulate_policy( policy, params, print, repeat )
    % Let policy be a function from state to index of feasible action
    
    % extract parameters
    T = params.T;
    feasible_set_f = params.feasible_set;
    contribution_f = params.contribution;
    possible_next_exo_f = params.possible_next_exo;
    possible_next_states_f = params.possible_next_states;
    transition_f = params.transition;
    
    contributions = zeros(T,1);
    totals = zeros(repeat,1);
    
    for m = 1:repeat

        state = params.initial_state;

        for t_i = 1:T
            t = t_i - 1;
            
            % get feasible actions
            actions = feasible_set_f(state, params); %actions(i,:) is the i-th action
            
            % apply policy to get 'optimal' action
            opt_action = actions(policy(state,t),:);
            
            % compute and save contribution given optimal action
            contributions(t_i) = contribution_f(state,opt_action,t);

            % decide which formulation to use
            if params.use_next_exo == 1    
                % get possible next exogenous information outcomes
                [W_next, W_probs] = possible_next_exo_f(state, opt_action, t); %next_exos(i,:) is the i-th exo
                % pick one at random and transition to next state
                W = W_next(randp(W_probs,[1,1]),:);
                next_state = transition_f(state,opt_action,t,W);
            else
               % get possible next state outcomes
               [S_next, S_probs] = possible_next_states_f(state, opt_action, t);
               % pick one at random
               next_state = S_next(randp(S_probs,[1,1]),:);                
            end
            if (print)
                fprintf('t = %d:\n', t);
                fprintf('    state = '); disp(state);
                fprintf('    decision = '); disp(opt_action);
                fprintf('    contribution = %f\n',contributions(t_i));
            end
            state = next_state;        
        end
        totals(m) = sum(contributions);
        fprintf('   total contribution = %f\n',totals(m));
    end
    mean_total = mean(totals);
    fprintf(' mean total contribution = %f\n', mean(totals));        
end


