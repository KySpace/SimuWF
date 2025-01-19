function gen = dspsdoublewell1(coeff, k_L, dist_well)
    k_R = k_L / 2;
    k_W = k_R * dist_well;
    function dsps = dspsgen(J, K, L)
        osci = -2*coeff*(cos(pi*tanh(L/k_W/2)*2) - ifthel(coeff > 0, 1, -1));
        dwell = osci .* cosh(L/k_W);
        dsps = dwell + (J / k_R).^2 + (K / k_R).^2;
    end
    gen = @dspsgen;
end