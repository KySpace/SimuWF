function mask = mmtcutoff(cutoff, J, K, L)
    mask = J.^2 + K.^2 + L.^2 < cutoff^2;
end