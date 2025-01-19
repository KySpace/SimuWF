%% This version aims to have better control on the center peak's sharpness
function gen = dspsdoublewell4(e_cent, e_edge, k_L, dist_well, dist_mark)
    k_R = k_L / 2;
    q_min = min(dist_well / 50, (1-dist_well) / 50);
    q_mark = dist_well * dist_mark;
    q_well = dist_well + q_min;
    e_mark = e_cent*sqrt(3)/2;
    q_anchor = [-1          -q_well -dist_well    -q_mark     0         q_mark   dist_well  q_well    1     ];
    e_anchor = [e_edge      0       0            e_mark    e_cent     e_mark   0          0         e_edge];
    function dsps = dspsgen(J, K, L)        
        dsps_L = makima(q_anchor, e_anchor, L/k_R);
        dsps = dsps_L + (J / k_R).^2 + (K / k_R).^2;
    end
    gen = @dspsgen;
end