function [ C ] = contribution( s, a, t, params )
    % P * (D + params.beta_d * x_rm - x_md)
    C = s(3) * (s(4) + params.beta_d * a(:,5) - a(:,2));
end

