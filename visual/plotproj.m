function [sc, hcntr, update, update_more] = plotproj(ax, pos, wf, dim, env)
    X = pos(:,1); Y = pos(:,2); Z = pos(:,3);
    xarr = sort(unique(X)); yarr = sort(unique(Y)); zarr = sort(unique(Z));
    reshapewf = @(wf) sum(reshape(wf, [numel(xarr) numel(yarr) numel(zarr)]), dim);
    wf_prfl = reshapewf(wf);    
    switch dim
        case 1; l_hori = "Z"; l_vert = "Y"; hori = zarr; vert = yarr; rmdim = @(A) reshape(A, size(A, [2,3]));
        case 2; l_hori = "Z"; l_vert = "X"; hori = zarr; vert = xarr; rmdim = @(A) reshape(A, size(A, [1,3]));
        case 3; l_hori = "X"; l_vert = "Y"; hori = xarr; vert = yarr; rmdim = @(A) reshape(A, size(A, [2,1]));
    end
    takemin = @(f) rmdim(min(reshape(f, [numel(xarr) numel(yarr) numel(zarr)]), [], dim));
    n_hori = numel(hori); n_vert = numel(vert);
    [clr, updateclr] = clrx(wf_prfl, amp="light");
    sc = imagesc(ax, hori, vert, 0);
    sz_clr = [n_vert n_hori 3];
    sc.CData = reshape(clr, sz_clr);   
    xlabel(ax, l_hori); ylabel(ax, l_vert);
    setlimfullarr(ax, hori, vert);
    if exist("env", "var") && numel(hori) > 1 && numel(vert) > 1 && ~isempty(env)
        env_prfl = takemin(env);
        [cntr, hcntr] = contour(ax, hori, vert, env_prfl, "LineColor", [0.4 0.4 0.4]);
        clabel(cntr, hcntr, "FontSize", 8, "Color", [0.4 0.4 0.4]);
    else; hcntr = [];
    end
    update = @(wf, env) updateimsc(sc, hcntr, sz_clr, updateclr, reshapewf(wf), ifthel(isempty(env), [], @() takemin(env)));
    update_more.toimage = @(clr) reshape(clr, sz_clr);
    update_more.reshaper = reshapewf;
    update_more.byclr = @(clr, env) updateimscclr(sc, hcntr, sz_clr, clr, ifthel(isempty(env), [], @() takemin(env)));
end

function updateimsc(p, h, sz, updateclr, wf, z)
    clr = updateclr(wf);
    p.CData = reshape(clr, sz);
    if ~isempty(h); h.ZData = z; end
end

function updateimscclr(p, h, sz, clr, z)
    p.CData = reshape(clr, sz);
    if ~isempty(h); h.ZData = z; end
end