function [ a_i ] = optimal_policy( A, s, t, params )
    % A is the state,t -> action index mapping, this function accesses a
    % specific element of A
    ts_cell = num2cell( [t,s(:)'] - [0,params.R_min,params.E_min,params.P_min,params.D_min] + 1 ); % index of the state (t,s)
    a_i = A(ts_cell{:});   % return the action index
end

