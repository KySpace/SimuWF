ax_band = setaxis(131, "dispersion bands");
ax_evol_rwb = setaxis(134, "micromotion in real wavevector space");
ax_band.Parent.Position = [ax_band.Parent.Position(1:2), 600, 1400];
ax_evol_rwb.Parent.Position = [ax_evol_rwb.Parent.Position(1:2), 1400, 600];

dict = struct();
dict.depth_latt = 1.6;
dict.max_shake = 0.3;
dict.ampl_sweep = [0 1];
dict.freq_sweep = 1.37:-0.01:0.75;
dict.step_qwv = 0.01;
dict.halfdim = 1;
dict.n_seq = 500;
bg = FreqSweepShakeBandGenerator;
bg.loadparams(dict)
bg.ready();
bg.run();

plotquasibands(ax_band, bg.qwv_norm, bg.band_freq_sweep(:,:,end), bg.freq_sweep(end)*4);
xlim(ax_band, [-1 1]);

evol_sbb = bg.wvfn_micro_finfreq_sbb;
evol_rwb = nan(size(evol_sbb));
for i_q = 1 : bg.n_qwv
    for i_t = 1 : bg.n_seq
        evol_rwb(:,:,i_t,i_q) = bg.wvfn_static_rwb(:,:,i_q) * evol_sbb(:,:,i_t,i_q);
    end
end
evol_dens = abs(squeeze(permute(evol_rwb(:,1,:,:), [3,4,1,2]))).^2;
evol_dens_uni = [evol_dens(:,1:end-2,1), evol_dens(:,1:end-2,2), evol_dens(:,1:end-3,3)];
wavevector = [bg.qwv_norm(1:end-2) - 2, bg.qwv_norm(1:end-2), bg.qwv_norm(1:end-3) + 2];
quasiwavevector = mod(wavevector + 1, 2) -1;
mask = abs(quasiwavevector) < 0.32 & abs(quasiwavevector) > 0.26;
mask_matrix = repmat(mask, [bg.n_seq, 1]);
evol_dens_uni_masked = evol_dens_uni;
evol_dens_uni_masked(:, ~mask) = nan;
openax(ax_evol_rwb)
ax_evol_rwb.Color = [0.4 0.4 0.4];
sc = imagesc(ax_evol_rwb, wavevector, (1:bg.n_seq)/bg.n_seq, evol_dens_uni);
colormap(ax_evol_rwb, "turbo");
alpha = 0.15;
sc.AlphaData = alpha + (1-alpha)*mask_matrix;
ax_evol_rwb.XLim = [-3 3]; ax_evol_rwb.YLim = [0 1];
shutax(ax_evol_rwb)


