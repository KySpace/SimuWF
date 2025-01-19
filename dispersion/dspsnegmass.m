function gen = dspsnegmass(neg_mass_rel, k_L)
    k_R = k_L / 2;
    function dsps = generate(J,K,L)
        dsps = (J.^2 + K.^2 - L.^2/neg_mass_rel)/k_R^2;
    end
    gen = constgen(@generate);
end