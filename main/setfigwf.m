function [fig, updaters, gobj] = setfigwf(pos, mmt, wf_pos, pttl, dsps, opt)  
    arguments
        pos
        mmt
        wf_pos
        pttl
        dsps
        opt
    end
    if ~ishandle(101); fig = figure(101); 
    else
        fig = findall(groot, "Type", "figure", "Number", 101);
        delete(findall(fig, type="annotation")); 
        delete(fig.Children);
    end
    sz = size(wf_pos);
    h_bot = 0.10; w_padd = 0.05; spacing = 0.05;  
    h_E = 0.3; h_wf =  0.5; 
    w_main = 1 - 2*w_padd; w_half = (w_main - 2*w_padd) / 2;
    ax_pos  = axes(fig);    
    ax_mmt  = axes(fig);
    ax_E    = axes(fig);    
    
    ax_E.Position    = [w_padd, h_bot, w_main, h_E];
    ax_pos.Position  = [w_padd, h_bot + h_E + spacing, w_half, h_wf];  
    ax_mmt.Position  = [3*w_padd + w_half, h_bot + h_E + spacing, w_half, h_wf];    
    
    keepax([ax_pos, ax_mmt])
    wf_mmt = fftshift(fftn(wf_pos));
    [sc_pos, cntr_pttl, update_pos] = plotproj(ax_pos, pos, wf_pos, 2, pttl);
    [sc_mmt, cntr_dsps, update_mmt] = plotproj(ax_mmt, mmt, wf_mmt, 2, dsps);
    shutax([ax_pos, ax_mmt])
    daspect(ax_pos, [1 1 1]); daspect(ax_mmt, [1 1 1]);

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

    if isfield(opt, "pos_xlim"); ax_pos.XLim = opt.pos_xlim; end
    if isfield(opt, "pos_ylim"); ax_pos.YLim = opt.pos_ylim; end
    if isfield(opt, "mmt_xlim"); ax_mmt.XLim = opt.mmt_xlim; end
    if isfield(opt, "mmt_ylim"); ax_mmt.YLim = opt.mmt_ylim; end

    updaters.pos = update_pos;
    updaters.mmt = update_mmt; 
    updaters.ann = update_ann; 
    updaters.E   = @update_E;

    gobj.ax_pos     = ax_pos;
    gobj.ax_mmt     = ax_mmt;
    gobj.ax_E       = ax_E;
    gobj.ann_step   = ann;
    gobj.sc_pos     = sc_pos;
    gobj.sc_mmt     = sc_mmt;
    gobj.cntr_pttl  = cntr_pttl;
    gobj.cntr_dsps  = cntr_dsps;
end

