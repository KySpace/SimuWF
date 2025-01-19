% This function naively couples 3 bands, located at 0, ± 1 order
% with a band shift from the second to the first band
% all couples are with the same coefficient, which is impractical
function [b_bi, b_fl] = shakebandnaive(v, omg, K, k)
arguments
    v           % coupling coefficient
    omg         % band shift
    K           % shift in k vector to create multiple bands
    k           % k vector
end
    bc2 = @bandcouplenaive;
    b1 = k.^2;
    b21 = (k-K).^2;
    b22 = (k+K).^2;
    be              = bc2(b21, b22, v);
    bg              = bc2(b1, be, v);
    [b_fl, b_bi]    = bc2(bg, be-omg*K^2, v);
end