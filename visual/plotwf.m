function sc = plotwf(ax, pos, wf)
    X = pos(:,1); Y = pos(:,2); Z = pos(:,3);        
    amp = abs(wf(:));
    amp_norm = amp / max(amp(:)) * 0.6;
    todraw = amp_norm > 0.1;
    wf = wf(todraw); amp_norm = amp_norm(todraw);
    ndraw = sum(todraw);
    sc = scatter3(ax, X(todraw), Y(todraw), Z(todraw), 'filled');
    sc.SizeData = 10;
    sc.AlphaData = amp_norm;
    sc.MarkerFaceAlpha = "flat";
    sc.CData = hsv2rgb([angle(wf(:))/2/pi+1/2, ones([ndraw 1]), ones([ndraw 1])]);
    daspect(ax, [1 1 1]);
    xlim(ax, [min(X(:)) max(X(:))]);
    ylim(ax, [min(Y(:)) max(Y(:))]);
    zlim(ax, [min(Z(:)) max(Z(:))]);
end