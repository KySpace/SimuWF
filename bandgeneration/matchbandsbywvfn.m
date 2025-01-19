% compare two sets of wavefunctions under the same basis by their
% correlations, find the most probable permutation of the new sets
% to match the old sets
% wvfn_ref, wvfn_new : dim × dim × n_qwv
function [ord, max_token] = matchbandsbywvfn(wvfn_ref, wvfn_new)
    dim = size(wvfn_ref, 1);
    all_perms = perms(1:dim);  
    n_perms = size(all_perms, 1);
    n_qwv = size(wvfn_ref, 3);
    correlation = nan([dim dim n_qwv]);
    for i_q = 1 : n_qwv
        correlation(:,:,i_q) = abs(wvfn_ref(:,:,i_q)' * wvfn_new(:,:,i_q)) .^ 2;
        correlation(:,:,i_q) = correlation(:,:,i_q)./sum(correlation(:,:,i_q), 1);
    end
    token = nan([1 n_perms]);
    for i_p = 1 : n_perms
        perm = all_perms(i_p, :);
        token(i_p) = sumdiag(correlation, perm);
    end
    [max_token, i_m] = max(token);
    ord = all_perms(i_m, :);
    if numel(unique(ord)) < dim
        error("shuffling failed");
    end
end

function s = sumdiag(corr, perm)
    s = 0;
    for i_q = 1 : size(corr, 3)
        s = s + sum(diag(corr(:,perm,i_q)));
    end
end