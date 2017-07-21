function [ W_next, W_probs ] = possible_next_exo( state, a, t, params )
    
    E_vals = [params.E_min:params.delta:params.E_max];
    P_vals = [params.P_min:params.delta:params.P_max];
    D_vals = [params.D_min:params.delta:params.D_max];

    E = state(2);
    P = state(3);

    next_t = t + 1;
    
    if strcmp(params.E_proc.noise_type,'normal') == 1
       E_noise_support = [-5:params.delta:5];
       E_probs = normpdf(E_noise_support,params.E_proc.mu_E,params.E_proc.sigma_E)...
           /sum(normpdf(E_noise_support,params.E_proc.mu_E,params.E_proc.sigma_E));
    else
       E_noise_support = [params.E_proc.u_a:params.delta:params.E_proc.u_b];
       E_probs = ones(size(E_noise_support))/length(E_noise_support);
    end
    
    E_next = max(params.E_min,min(E + E_noise_support,params.E_max));
    
    if strcmp(params.P_proc.type,'sinusoidal') == 1
       P_noise_support = [-8:params.delta:8];
       P_probs = normpdf(P_noise_support,params.P_proc.mu_P,params.P_proc.sigma_P)...
           /sum(normpdf(P_noise_support,params.P_proc.mu_P,params.P_proc.sigma_P));
       P_next = max(params.P_min,min(floor(40 - 10*sin(5*pi*next_t/params.T)) + P_noise_support,params.P_max));
    elseif strcmp(params.P_proc.type,'mc') == 1
       P_noise_support = [-8:params.delta:8];
       P_probs = ones(size(P_noise_support))/length(P_noise_support);
       P_next = max(min(P + P_noise_support, params.P_max), params.P_min);
    else %mc_jump
       P_noise_1_support = [-8:params.delta:8];
       P_noise_1_probs = normpdf(P_noise_1_support,params.P_proc.mu_P,params.P_proc.sigma_P)...
           /sum(normpdf(P_noise_1_support,params.P_proc.mu_P,params.P_proc.sigma_P));
       
       P_noise_2_support = [0,1];
       P_noise_2_probs = [0.031,1-0.031];
       
       P_noise_3_support = [-40:params.delta:40];
       P_noise_3_probs = normpdf(P_noise_3_support,0,50)...
           /sum(normpdf(P_noise_3_support,0,50));
       
       [o1, o2, o3] = ndgrid(P_noise_1_support,P_noise_2_support,P_noise_3_support);
       [p1, p2, p3] = ndgrid(P_noise_1_probs, P_noise_2_probs, P_noise_3_probs);
       
       P_noise_support = o1(:) + o2(:) .* o3(:);
       P_probs = p1(:) .* p2(:) .* p3(:);
       P_next = max(min(P + P_noise_support, params.P_max), params.P_min);
    end
    
    if strcmp(params.D_proc.type,'sinusoidal') == 1
       D_noise_support = [-2:params.delta:2];
       D_probs = normpdf(D_noise_support,params.D_proc.mu_D,params.D_proc.sigma_D)...
           /sum(normpdf(D_noise_support,params.D_proc.mu_D,params.D_proc.sigma_D));
       D_next = max(params.D_min,min(floor(3 - 4*sin(2*pi*next_t/params.T)) + D_noise_support,params.D_max));
    end
    
    % sweep through all values and make everything unique (otherwise ndgrid
    % blows up)
    E_unique_probs = zeros(size(E_vals));
    P_unique_probs = zeros(size(P_vals));
    D_unique_probs = zeros(size(D_vals));
    
    for i = 1:length(E_vals)
        El = E_vals(i);
        E_unique_probs(i) = sum(E_probs(E_next == El));      
    end
    
    for i = 1:length(P_vals)
        Pl = P_vals(i);
        P_unique_probs(i) = sum(P_probs(P_next == Pl));
    end
    
    for i = 1:length(D_vals)
        Dl = D_vals(i);
        D_unique_probs(i) = sum(D_probs(D_next == Dl));
    end
    
    keep_E = E_unique_probs > 0;
    keep_P = P_unique_probs > 0;
    keep_D = D_unique_probs > 0;
    
    E_vals = E_vals(keep_E);
    P_vals = P_vals(keep_P);
    D_vals = D_vals(keep_D);
    
    E_unique_probs = E_unique_probs(keep_E);
    P_unique_probs = P_unique_probs(keep_P);    
    D_unique_probs = D_unique_probs(keep_D);
    
    [o1, o2, o3] = ndgrid(E_vals,P_vals,D_vals);
    [p1, p2, p3] = ndgrid(E_unique_probs,P_unique_probs,D_unique_probs);
    
    W_next = [o1(:) o2(:) o3(:)];
    W_probs = p1(:) .* p2(:) .* p3(:);
    
end

