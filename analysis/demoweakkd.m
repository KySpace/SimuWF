ax = setaxis(181, "density");
dict = struct();
dict.depth_latt = 1.6;
dict.max_shake = nan;
dict.shake_phase = nan;
dict.ampl_sweep = [0 1];
dict.freq_sweep = 1.37:-0.01:0.75;
dict.step_qwv = 0.01;
dict.halfdim = 1;
dict.n_seq = 500;
bg = FreqSweepShakeBandGenerator;

for depth_latt = 1.4: 0.2 : 3.2    
    dict.depth_latt = depth_latt;
    bg.loadparams(dict)
    bg.ready();
    
    wvfn_static_rwb_zs = bg.wvfn_static_rwb(:,:,bg.i_q_zs);
    wvfn_init_rwb = zeros(bg.dim, 1); wvfn_init_rwb(bg.halfdim+1) = 1;
    wvfn_init_sbb = inv(wvfn_static_rwb_zs) * wvfn_init_rwb;
    t_samples = linspace(0,5,100);
    wvfn_rwb = nan(bg.dim, 100);
    for i_t = 1 : 100
        t = t_samples(i_t);
        wvfn_sbb_t = wvfn_init_sbb .* exp(1i*t*bg.band_static_rwb(:,bg.i_q_zs));
        wvfn_rwb_t = wvfn_static_rwb_zs * wvfn_sbb_t;
        wvfn_rwb(:,i_t) = wvfn_rwb_t;
    end
    keepax(ax)
    plot(ax, t_samples, abs(wvfn_rwb).^2); 
    ylim(ax, [-0.05 1.05]);
    shutax(ax)
end

