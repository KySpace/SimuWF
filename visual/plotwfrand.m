function sc = plotwfrand(ax, X, Y, Z, pos, wf)
    Xq = pos(:,1); Yq = pos(:,2); Zq = pos(:,3);
    wfq = interp3(X, Y, Z, wf, Xq, Yq, Zq, "linear");
    sc = plotwf(ax, pos, wfq);
end