% the continuity on the zone edges are turned off
function gen = dspscoszdiscont(coeff, k_L, val_max)
arguments
    coeff       
    k_L
    val_max         = Inf
end
    k_R = k_L / 2;
    function dsps = dspsgen(~, ~, L)
        dsps = -2*coeff*(cos(pi*L/k_R) - ifthel(coeff > 0, 1, -1));
        l_zoneedge = k_R - 1e-10;
        dsps(abs(L) >= l_zoneedge) = val_max;
    end
    gen = @dspsgen;
end