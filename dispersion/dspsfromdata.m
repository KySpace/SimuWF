function dsps = dspsfromdata(datapath, depth_latt, freq_shake_rel, ampl_shake_rel, k_L, bandidx)
arguments
    datapath
    depth_latt 
    freq_shake_rel
    ampl_shake_rel
    k_L
    bandidx             = 1
end
    k_R = k_L / 2;
    function dsps = generate(J,K,L)
        sz = size(J);
        l = unique(L);
        band = loadbandfromdata(datapath, depth_latt, ...
                    ampl_shake_rel, freq_shake_rel, bandidx, l/k_R);
        grid_band = permute( ndgrid( band, ...
                                     nan([1 sz(1)]), ...
                                     nan([1 sz(2)]) ), ...
                             [2 3 1]);
        dsps = grid_band + 1*(J.^2+K.^2)/k_R^2;
        dsps = dsps - min(dsps, [], "all");
    end
    dsps = @generate;
end