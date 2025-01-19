function [runlogs, phasediagram] = mkphasediagram(testpath)

    schminfo = loadschminfo(testpath, fn_vary=["freq_shake_rel" "ampl_shake_rel"]);
    if_freq = find(schminfo.fn_vary == "freq_shake_rel");
    if_ampl = find(schminfo.fn_vary == "ampl_shake_rel");
    runlogs = cell(1, schminfo.n_variation);
    phasediagram = nan([schminfo.sz_vary(if_freq), schminfo.sz_vary(if_ampl) 4]);
    freqs = cell2mat(schminfo.cand_vary{if_freq});
    ampls = cell2mat(schminfo.cand_vary{if_ampl});

    function logrun(idx, idx_raw, schminfo, maxrun, framedata)
        testinfo.vars = accessvary(schminfo, (idx_raw));
        testinfo.brief = runbrief(schminfo.fn_vary, testinfo.vars, idx, maxrun);
        testinfo.frames = framedata;
        runlogs{idx} = struct("info", testinfo, "data", []);
    end
    function anlzatframe(idx, frameidx, time, wf_pos, wf_mmt, framedata, outputpath)
        if abs(time - 0.4) < 0.01
            [~, sub] = accessvary(schminfo, idx);
            halfsz = framedata.halfsz; halfsz(2) = 1;
            [J, K, L] = gengridsmmt(halfsz, framedata.dr);
            dens = sum(abs(wf_mmt).^2, 2);
            [moment2_dist_com, moment2_dist_origin, dist_com, deg_com] = anlzlrc(dens, L, J);
            phasediagram(sub(if_freq), sub(if_ampl), :) = [moment2_dist_com, moment2_dist_origin, dist_com, deg_com];
        end
    end
    function plotall(~)
        ax_com = setaxis(161, "two center of mass distance");
        ax_com_m = setaxis(162, "concentration around the two center of masses");
        ax_origin_m = setaxis(163, "concentration around the origin");
        ax_deg = setaxis(164, "center of mass degree");
        imagesc(ax_com, ampls, freqs, phasediagram(:,:,3))
        imagesc(ax_com_m, ampls, freqs, phasediagram(:,:,1))
        imagesc(ax_origin_m, ampls, freqs, phasediagram(:,:,2))
        imagesc(ax_deg, ampls, freqs, phasediagram(:,:,4))
        colorbar(ax_deg); colorbar(ax_com);
    end

    anlzfrompath(testpath, {@anlzatframe}, @logrun, {}, {@plotall});

end