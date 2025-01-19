function genphasediagram(testpath)


fig1 = figure(31);
fig1.Position = [fig1.Position(1:2) 480 480];
clearfigs(fig1);
ax1 = axes(fig1, Units="pixels");
ax1.Position = [40 40 400 400];
fig2 = figure(32);
fig2.Position = [fig2.Position(1:2) 480 480];
set(fig2, "Color", "none")
clearfigs(fig2);
ax2 = axes(fig2, Color="none",  Units="pixels");
ax2.Position = [40 40 400 400];


testinfo = [];

function logrun(idx, idx_raw, schminfo, maxrun, framedata, simuresult, outputpath)
    testinfo = struct();
    [testinfo.vars, ~, testinfo.subs] = accessvary(schminfo, (idx_raw));
    testinfo.brief = runbrief(schminfo.fn_vary, testinfo.vars, idx, maxrun);
    testinfo.frames = framedata;
    s = simuresult;
    halfsz = (size(s.X) - 1)/2;
    dsps = squeeze(s.dsps(halfsz(1)+1,halfsz(2)+1,:));
    plot(ax2, unique(s.L(:)), dsps - min(dsps), LineWidth=4);
    removeallticks(ax2);
    ylim(ax2, [0 4]);
    subs = testinfo.subs;
    saveas(ax2, sprintf("%s\\DispersionSegment.[i_f=%i].[i_a=%i].svg", outputpath, ...
        subs.freq_shake_rel, subs.ampl_shake_rel), "svg");
end

function saveframeasmmtimage(idx, frameidx, time, wf_pos, wf_mmt, framedata, outputpath)  
    if abs(time - 0.4) > 0.02; return; end
    subs = testinfo.subs;
    [X, Y, Z] = gengridspos(framedata.halfsz, framedata.dr);
    [J, K, L] = gengridsmmt(framedata.halfsz, framedata.dr);
    pos = [X(:), Y(:), Z(:)];
    mmt = [J(:), K(:), L(:)];
    % [~,~,~,u] = plotproj(ax1, pos, wf_pos, 2, []);
    % img_clr = clrx(abs(u.reshaper(wf_mmt)).^2, amp="light", rad_red=0);
    % u.byclr(img_clr, []);
    % img = u.toimage(img_clr);
    imagesc(ax1, unique(J(:)), unique(L(:)), squeeze(mean(abs(wf_mmt.^2), 2)));
    colormap(ax1, crameri('-turku'));
    axis(ax1, "image");
    removeallticks(ax1);
    saveas(ax1, sprintf("%s\\Momentum.[i_f=%i].[i_a=%i].[frame=%i].svg", outputpath, ...
        subs.freq_shake_rel, subs.ampl_shake_rel, frameidx), "svg");
end

anlzfrompath(testpath, {@saveframeasmmtimage}, @logrun, {@trivial}, {@trivial});

end
