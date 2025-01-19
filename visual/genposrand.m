function pos = genposrand(halfsz, n)
arguments
    halfsz      (1,3)
    n           (1,1)
end
    sz = [n 3];
    pos = (2 * rand(sz) - 1) .* halfsz;
end