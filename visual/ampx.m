function amp_rel = ampx(c, op)
arguments
    c
    op.max         
    op.scale    = 1;
end
    a = abs(c(:)); maxa = max(a(:));
    if isfield(op, "max"); op.scale = op.max / maxa; end
    amp_rel = a * op.scale;
end