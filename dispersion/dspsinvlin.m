function gen = dspsinvlin(slope, k_L)
    k_R = k_L / 2;
    function dsps = generate(J,K,L)
        dsps = (J.^2 + K.^2)/k_R^2 - slope*(abs(L/k_R));
    end
    gen = constgen(@generate);
end