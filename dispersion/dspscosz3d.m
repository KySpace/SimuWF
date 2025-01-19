function gen = dspscosz3d(coeff, k_L)
    k_R = k_L / 2;
    function dsps = dspsgen(J, K, L)
        dsps = -2*coeff*(cos(pi*L/k_R) - ifthel(coeff > 0, 1, -1)) ...
            + (J / k_R).^2 + (K / k_R).^2;
    end
    gen = @dspsgen;
end