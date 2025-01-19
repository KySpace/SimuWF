function gen = dspssharp3d(coeff, k_L)
    k_R = k_L / 2;
    function dsps = dspsgen(J, K, L)
        dsps = -4*coeff*(1-abs(L/k_R)) ...
            + (J / k_R).^2 + (K / k_R).^2;
    end
    gen = @dspsgen;
end