function [ next_state ] = transition( s, a, t, W, params )
    % resource transition
    R = s(1);
    phi = [0, 0, -1, params.beta_c, -1]';
    R_next = R + a * phi;
    
    % concatenate with exogenous information transition
    next_state = [R_next, W];
end

