function outputpath = mkshakebandtable(testpath)
[schminfo, idxlist] = loadschminfo(testpath, fn_vary=["depth_latt" "max_shake"]);
outputpath = sprintf("%s\\AnalysisOutput", testpath); mkdir(outputpath);

% sample
load(testpath + "\1.ShakeBands.mat", "saveddata");
bandgendata = saveddata;

[depth_latt, ord_v] = sort(cell2mat(schminfo.cand_vary{2}));
[max_shake , ord_x] = sort(cell2mat(schminfo.cand_vary{1}));
[freq_sweep, ord_f] = sort(bandgendata.freq_sweep);
qwv_norm        = bandgendata.qwv_norm;
bandidx         = 1 : bandgendata.dim;

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

for idx = 1 : schminfo.n_variation
    load(sprintf("%s\\%i.ShakeBands.mat", testpath, idx), "saveddata");
    bandgendata = saveddata;
    idx_raw = idxlist(idx);
    [~, sub] = accessvary(schminfo, idx_raw);
    band_swept = permute(bandgendata.band_freq_sweep(:,:,ord_f), [3 1 2]);
    quasienergy(ord_v == sub(2), ord_x == sub(1), :, :, :) = band_swept;
end
save(outputpath + "\BandTable.mat", "name_dim", "quasienergy", "testpath", ...
    "depth_latt", "max_shake", "freq_sweep", "bandidx", "qwv_norm", ...
    "grid_depth_latt", "grid_max_shake", "grid_freq_sweep", "grid_bandidx", "grid_qwv_norm");
fprintf("Data output to %s \n", outputpath);
end