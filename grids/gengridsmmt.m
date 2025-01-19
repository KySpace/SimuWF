function [J, K, L] = gengridsmmt(halfsz, dr)
    [J, K, L] = gengrids(1./dr, 1./halfsz);
    J = pi * J;
    K = pi * K;
    L = pi * L;
end