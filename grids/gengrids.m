function [X, Y, Z] = gengrids(halfsz, d)
% when d is infinite, the new halfsz will be 0 at that coordinate
halfsz = floor(2*halfsz ./ d) .* d/2;
halfsz(isnan(halfsz)) = 0;
[X, Y, Z] = ndgrid(   -halfsz(1):d(1):+halfsz(1), ...
                      -halfsz(2):d(2):+halfsz(2), ...
                      -halfsz(3):d(3):+halfsz(3)    );
end