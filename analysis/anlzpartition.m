function alltests = anlzpartition(testpath)

schminfo = loadschminfo(testpath);
alltests = cell(1, schminfo.n_variation);

fig = figure(1);
clearfigs(fig);
ax1 = axes(fig); ax2 = axes(fig);
ax1.Position = [0.06 0.11 0.44 0.815];
ax2.Position = [0.56 0.11 0.44 0.815];

fig3 = figure(102); clearfigs(fig3);
ax3 = setaxis(102, "separation and degree");

function logrun(idx, idx_raw, schminfo, maxrun, framedata)
    testinfo.vars = accessvary(schminfo, (idx_raw));
    testinfo.brief = runbrief(schminfo.fn_vary, testinfo.vars, idx, maxrun);
    testinfo.frames = framedata;
    alltests{idx} = struct("info", testinfo, "data", []);
end

function anlzpartition(idx, frameidx, time, wf_pos, wf_mmt, framedata, outputpath)   

    [X, Y, Z] = gengridspos(framedata.halfsz, framedata.dr);
    [J, K, L] = gengridsmmt(framedata.halfsz, framedata.dr);
    pos = [X(:), Y(:), Z(:)];

    wf_p_mmt = wf_mmt .*  (L > 0);
    wf_n_mmt = wf_mmt .*  (L < 0);
    wf_p = ifftn(ifftshift(wf_p_mmt));
    wf_n = ifftn(ifftshift(wf_n_mmt));
    openax(ax1)
    [~,~,~,u] = plotproj(ax1, pos, wf_pos, 2, []);
    clr_p = clrx(abs(u.reshaper(wf_p)).^2, amp="light", rad_red=0);
    clr_n = clrx(abs(u.reshaper(wf_n)).^2, amp="light", rad_red=0.5);
    clr = (clr_p + clr_n) / 2;
    u.byclr(clr, []);
    shutax(ax1)
    im_part = u.toimage(clr);

    imwrite(im_part, sprintf("%s\\RealspacePartition.[idx=%i].[frame=%i].bmp", outputpath, idx, frameidx), "bmp");
end

function anlztrajectory(idx, frameidx, time, wf_pos, wf_mmt, framedata, outputpath)    
    testdata = alltests{idx}.data;    
    if isempty(testdata); testdata = nan([5, length(framedata.log)]); end

    [J, K, L] = gengridsmmt(framedata.halfsz, framedata.dr);

    wf_p_mmt = wf_mmt .*  (L > 0);
    wf_n_mmt = wf_mmt .*  (L < 0);
    k_R = 2 * pi / 1.064;
    
    density_all = abs(wf_mmt).^2;
    density_p = abs(wf_p_mmt) .^ 2 / sum(density_all, "all");
    density_n = abs(wf_n_mmt) .^ 2 / sum(density_all, "all");
    peakp = [sum(density_p .* J, "all"), sum(density_p .* K, "all"), sum(density_p .* L, "all")];
    peakn = [sum(density_n .* J, "all"), sum(density_n .* K, "all"), sum(density_n .* L, "all")];
    distsq_com_p = ((J - peakp(1)).^2 + (K - peakp(2)).^2 + (L - peakp(3)).^2) / k_R^2;
    distsq_com_n = ((J - peakn(1)).^2 + (K - peakn(2)).^2 + (L - peakn(3)).^2) / k_R^2;
    moment_dist_com = sqrt(sum(distsq_com_p .* density_p + distsq_com_n .* density_n, "all"));
    moment_dist_org = sum((J.^2 + K.^2 + L.^2) .* (density_n + density_p), "all") / sum(density_p + density_n, "all");
    dist_rel = (peakp - peakn) / k_R;
    testdata(:,frameidx) = [ sqrt(sum(dist_rel .* dist_rel)) / 2; ...
                             atan2d(dist_rel(1), dist_rel(3)); ...
                             moment_dist_com; ...
                             moment_dist_org; ...
                             time ];
    alltests{idx}.data = testdata;
end

function wrapupframes(idx, ~, ~) 
    d = alltests{idx}.data;
    keepax(ax3)
    yyaxis(ax3, "left");
    plot(d(5,:), d(1,:));
    yyaxis(ax3, "right");
    plot(d(5,:), d(2,:));
    shutax(ax3)    
end

function wrapupall(outputpath)
    saveas(ax3, outputpath + "/sepdeg.fig");
    save(outputpath + "/testresult.mat", "alltests");
end

anlzfrompath(testpath, {@anlztrajectory, @anlzpartition}, @logrun, {@wrapupframes}, {@wrapupall});

end