function mat = gencheckboardmat(sz)
arguments
    sz      (1,:)
end
    [x,y,z] = ndgrid(1 : sz(1), ...
                     1 : sz(2), ...
                     1 : sz(3) );
    mat = exp(1i * pi * (x+y+z));
end

