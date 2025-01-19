function [c1, c2] = bandcouplenaive(b1, b2, v)
    avg = (b1 + b2)/2;
    gap = sqrt( 1/4*(b1 - b2).^2 + v^2 );
    c1 = avg - gap;
    c2 = avg + gap;
end