function outputpath = mkshakebandtablemod(freq_std, testpath, outputpath)
arguments
    freq_std
    testpath
    outputpath      = sprintf("%s\\AnalysisOutput", testpath);
end
% this is the standard frequency where band orders of different frequencies
% comply to
[schminfo, idxlist] = loadschminfo(testpath, fn_vary=["depth_latt" "max_shake"]);
mkdir(outputpath);

% sample
load(testpath + "\1.ShakeBands.mat", "saveddata");
bandgendata = saveddata;
[~, i_q_zs] = min(abs(bandgendata.qwv_norm));

[depth_latt, ord_v] = sort(cell2mat(schminfo.cand_vary{2}));
[max_shake , ord_x] = sort(cell2mat(schminfo.cand_vary{1}));
[freq_sweep, ord_f] = sort(bandgendata.freq_sweep);
qwv_norm        = bandgendata.qwv_norm;
bandidx         = 1 : (bandgendata.halfdim * 2 + 1);

name_dim        = ["depth_latt" "max_shake" "freq_sweep" "band_index" "quasiwavevector"];
[   grid_depth_latt , ...
    grid_max_shake  , ...
    grid_freq_sweep , ...
    grid_bandidx    , ...
    grid_qwv_norm     ] = ndgrid(   depth_latt  , ...
                                    max_shake   , ...
                                    freq_sweep  , ...
                                    bandidx     , ...
                                    qwv_norm    );
quasienergy = nan(size(grid_depth_latt));
[~, idx_freq_std] = min(abs(freq_sweep - freq_std));

for idx = 1 : schminfo.n_variation
    load(sprintf("%s\\%i.ShakeBands.mat", testpath, idx), "saveddata");
    bandgendata = saveddata;
    idx_raw = idxlist(idx);
    [~, sub] = accessvary(schminfo, idx_raw);
    % dim : f, b, q
    band_swept = permute(bandgendata.band_freq_sweep(:,:,ord_f), [3 1 2]);
    % band_swept_reorder = nan(size(band_swept));
    % dim : basis, b, q, f
    wvfn_swept = permute(bandgendata.wvfn_shake_sbb(:,:,:, ...
                            ord_f + numel(bandgendata.ampl_sweep)), ...
                            [1,2,3,4]);
    wvfn_std = wvfn_swept(:, :, :, idx_freq_std);
    wvfn_last = wvfn_std;
    for idx_freq = idx_freq_std : 1 : numel(freq_sweep)
        wvfn_this = wvfn_swept(:, :, :, idx_freq);
        ord_bands = matchbandsbywvfn(wvfn_last, wvfn_this);
        wvfn_this = wvfn_this(:,ord_bands,:);
        band_swept(idx_freq,:,:) = band_swept(idx_freq,ord_bands,:);
        wvfn_last = wvfn_this;
    end
    % for idx_freq = 1 : numel(freq_sweep)
    %     periodE = 4*freq_sweep(idx_freq);
    %     % band_swept(idx_freq,:,:) = shfttribands(squeeze(band_swept(idx_freq,:,:)), i_q_zs, 4*freq_sweep(idx_freq));
    %     plotquasibands2(ax, qwv_norm, squeeze(band_swept(idx_freq, :, :)), 4*freq_sweep(idx_freq));
    %     ax.XLim = [-1 1];
    %     ax.YLim = [-4,4];
    %     % pause(0.02);
    %     drawnow;
    % end
    quasienergy(ord_v == sub(2), ord_x == sub(1), :, :, :) = band_swept;
end


save(outputpath + "\BandTable.mat", "name_dim", "quasienergy", "testpath", ...
    "depth_latt", "max_shake", "freq_sweep", "bandidx", "qwv_norm", ...
    "grid_depth_latt", "grid_max_shake", "grid_freq_sweep", "grid_bandidx", "grid_qwv_norm");
fprintf("Data output to %s \n", outputpath);
end

% bands dimension: b, q
function bands_o = shfttribands(bands, i_zs, period)
    bands_o = nan(size(bands));
    [min_band1, i_q_cross] = min(bands(1,:));
    % the first band will have it's minimum value just below 0
    bands_o(1,:) = bands(1,:) - ceil(min_band1/period);
    % the second band will have it's zs just below zs of band 1
    bandgap_12 = bands(2,i_q_cross) - bands(1,i_q_cross);
    bands_o(2,:) = bands(2,:) - ceil(bandgap_12/period);
    % the third band will have it's zs just above zs of band 1
    bandgap_13 = bands(3,i_zs) - bands(1,i_zs);
    bands_o(3,:) = bands(3,:) - floor(bandgap_13/period);
end