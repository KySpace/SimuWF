function gen = dspsinverted(neg_mass_rel, k_L)
    k_R = k_L / 2;
    function dsps = generate(J,K,L)
        dsps = (J.^2 + K.^2)/k_R^2 + cos(2*pi*L/k_L)/neg_mass_rel;
    end
    gen = constgen(@generate);
end