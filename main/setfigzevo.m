function [fig, updaters, gobj] = setfigzevo(pos, mmt, wf_pos, pttl, dsps, t)
    arguments
        pos
        mmt
        wf_pos
        pttl
        dsps
        t
    end
    if ~ishandle(102); fig = figure(102); 
    else
        fig = findall(groot, "Type", "figure", "Number", 102);
        delete(findall(fig, type="annotation")); 
        delete(fig.Children);
    end
    sz = [size(wf_pos, 3), numel(t)];
    h_bot = 0.10; w_padd = 0.05; spacing = 0.05;  
    h_E = 0.3; h_wf =  0.5; 
    w_main = 1 - 2*w_padd; w_half = (w_main - 2*w_padd) / 2;
    ax_pos  = axes(fig);    
    ax_mmt  = axes(fig);
    ax_E    = axes(fig);  

    ax_E.Position    = [w_padd, h_bot, w_main, h_E];
    ax_pos.Position  = [w_padd, h_bot + h_E + spacing, w_half, h_wf];  
    ax_mmt.Position  = [3*w_padd + w_half, h_bot + h_E + spacing, w_half, h_wf];  
    
    sum_zl = @(wf) squeeze(sum(sum(abs(wf).^2, 1), 2));

    keepax([ax_pos, ax_mmt])
    z = unique(pos(:,3));
    l = unique(mmt(:,3));
    sc_pos = imagesc(ax_pos, t, z, nan(sz));
    sc_mmt = imagesc(ax_mmt, t, l, nan(sz));
    colormap(ax_pos, "turbo");
    colormap(ax_mmt, "turbo");
    xlim(ax_pos, [-0 max(t)]); ylim(ax_pos, [min(z) max(z)]);
    xlim(ax_mmt, [-0 max(t)]); ylim(ax_mmt, [min(l) max(l)]);
    shutax([ax_pos, ax_mmt])

    ann = annotation(fig, textbox=[0 0 0.3000 0.0600], LineStyle="none", String="step:", FontName="Consolas");
    function updatetimestamp(runnum, runmax, t, ntrc)
        ann.String = sprintf("step: %4i/%4i | time : %2.3f ms | interaction = %f", ...
            runnum, runmax, t, ntrc);
    end
    update_ann = @updatetimestamp;
    function update_E(t,E) 
        plot(ax_E,t,E);
        legend(ax_E, ["T", "V", "I", "tot"], Location="southwest");
    end
    function update_pos(wf, iter_now)
        cdata = sc_pos.CData;
        cdata(:, iter_now) = sum_zl(wf);
        sc_pos.CData = cdata;
    end
    function update_mmt(wf, iter_now)
        cdata = sc_mmt.CData;
        cdata(:, iter_now) = sum_zl(wf);
        sc_mmt.CData = cdata;
    end

    updaters.pos = @update_pos;
    updaters.mmt = @update_mmt; 
    updaters.ann = update_ann; 
    updaters.E   = @update_E;

    gobj.ax_pos     = ax_pos;
    gobj.ax_mmt     = ax_mmt;
    gobj.ax_E       = ax_E;
    gobj.ann_step   = ann;
    gobj.sc_pos     = sc_pos;
    gobj.sc_mmt     = sc_mmt;
end