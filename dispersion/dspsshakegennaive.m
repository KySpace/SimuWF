function gen = dspsshakegen(coupling_coeff, bandshift, k_L, k_R)
    function dsps = generate(J,K,L)
        dsps = shakebandnaive(coupling_coeff, bandshift, k_L/k_R, L/k_R) ...
            + (J.^2+K.^2)/k_R^2;
    end
    gen = @generate;
end