function gen = dspscosz(coeff, k_L)
    k_R = k_L / 2;
    function dsps = dspsgen(~, ~, L)
        dsps = -2*coeff*(cos(pi*L/k_R) - ifthel(coeff > 0, 1, -1));
    end
    gen = @dspsgen;
end