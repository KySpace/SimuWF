%% This version goes up naturally extending the cosine
function gen = dspsdoublewell5(e_cent, k_L, dist_well)
    k_R = k_L / 2;
    q_unit = dist_well / 2;
    q_marks = q_unit*[1/3, 2/3, 1, 4/3, 5/3, 2, 7/3, 8/3, 3];
    e_marks = e_cent*(1/2+1/2*[sqrt(3)/2 1/2 0 -1/2 -sqrt(3)/2 -1 -sqrt(3)/2 -1/2 0]);
    e_edge = 100*e_cent*(1/2+(1-3*q_unit)*pi/4/q_unit);
    q_anchor = [-1     -fliplr(q_marks)     0     q_marks      1     ];
    e_anchor = [e_edge, fliplr(e_marks),  e_cent, e_marks, e_edge];
    function dsps = dspsgen(J, K, L)        
        dsps_L = makima(q_anchor, e_anchor, L/k_R);
        dsps = dsps_L + (J / k_R).^2 + (K / k_R).^2;
    end
    gen = @dspsgen;
end