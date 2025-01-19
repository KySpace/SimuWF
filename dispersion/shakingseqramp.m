function dsps_gen = shakingseqramp(datapath, depth_latt, freq_shake_rel_i, freq_shake_rel_f, t_ramp, ampl_shake_rel, k_L, bandidx)
arguments
    datapath
    depth_latt 
    freq_shake_rel_i
    freq_shake_rel_f
    t_ramp
    ampl_shake_rel
    k_L
    bandidx             = 1
end
    k_R = k_L / 2;
    function freq_rel = freq_rel(t)
        freq_rel = ifthel(  t < t_ramp, ...
                            (t/t_ramp) * (freq_shake_rel_f - freq_shake_rel_i) + freq_shake_rel_i, ...
                            freq_shake_rel_f );
    end
    function gen_t = generate(J,K,L)
        sz = size(J);
        l = unique(L);
        function dsps = dsps_t(t)
            band = loadbandfromdata(datapath, depth_latt, ...
                        ampl_shake_rel, freq_rel(t), bandidx, l/k_R);
            grid_band = permute( ndgrid( band, ...
                                         nan([1 sz(1)]), ...
                                         nan([1 sz(2)]) ), ...
                                 [2 3 1]);
            dsps = grid_band + 1*(J.^2+K.^2)/k_R^2;
        end
        gen_t = @dsps_t;
    end
    dsps_gen = @generate;
end