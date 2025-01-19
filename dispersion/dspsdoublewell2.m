%% This version aims to have better control on energy scaling
function gen = dspsdoublewell2(e_cent, e_edge, k_L, dist_well)
    k_R = k_L / 2;
    q_min = min(dist_well / 20, (1-dist_well) / 20);
    q_anchor = [-1          -(dist_well+q_min) -q_min q_min  (dist_well+q_min)    1];
    e_anchor = [e_edge            0            e_cent e_cent       0         e_edge];
    function dsps = dspsgen(J, K, L)        
        dsps_L = pchip(q_anchor, e_anchor, L/k_R);
        dsps = dsps_L + (J / k_R).^2 + (K / k_R).^2;
    end
    gen = @dspsgen;
end