function wvfn = normalizewvfn(V) 
    wvfn = V ./ sqrt(sum(abs(V' * V), 1));
end