% compare two sets of wavefunctions under the same basis by their
% correlations, find the most probable permutation of the new sets
% to match the old sets
% wvfn_ref, wvfn_new : dim × dim
function [ord, max_token] = matchwvfnsets(wvfn_ref, wvfn_new)
    dim = size(wvfn_ref, 1);
    all_perms = perms(1:dim);  
    n_perms = size(all_perms, 1);
    correlation = abs(wvfn_ref' * wvfn_new) .^ 2;
    correlation = correlation./sum(correlation, 1);
    token = nan([1 n_perms]);
    for i_p = 1 : n_perms
        perm = all_perms(i_p, :);
        token(i_p) = sum(diag(correlation(:,perm)));
    end
    [max_token, i_m] = max(token);
    ord = all_perms(i_m, :);
    if numel(unique(ord)) < dim
        error("shuffling failed");
    end
end