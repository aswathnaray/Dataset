function [decisions ] = feasible_set( state, t, params )

    R = state(1);
    E = state(2);
    D = state(4);
    
    % possible decisions (to be narrowed down below)
    poss_xRD = [0:params.delta:min(params.R_max,params.gamma_d)];
    poss_xRG = [0:params.delta:min(params.R_max,params.gamma_d)];
    poss_xWR = [0:params.delta:min(min(params.R_max-R,params.gamma_c),E)];
    poss_xWD = [0:params.delta:params.E_max];
    poss_xGD = [0:params.delta:D];
    
    [xWDs, xGDs, xRDs, xWRs, xRGs] = ...
        ndgrid(poss_xWD,poss_xGD,poss_xRD,poss_xWR,poss_xRG);
    
    xWDs = xWDs(:);
    xGDs = xGDs(:);
    xRDs = xRDs(:);
    xWRs = xWRs(:);
    xRGs = xRGs(:);
    
    decisions = [xWDs, xGDs, xRDs, xWRs, xRGs];
    
    % constraints
    c_2 = (xWDs + params.beta_d * xRDs + xGDs == D);
    c_3 = (xRDs + xRGs <= R);
    c_4 = (xWRs <= params.R_max - R);
    c_5 = (xWRs + xWDs <= E);
    c_6 = (xWRs <= params.gamma_c);
    c_7 = (xRDs + xRGs <= params.gamma_d);
    
    % only keep the feasible decisions
    decisions = decisions(c_2 & c_3 & c_4 & c_5 & c_6 & c_7,:);
end


