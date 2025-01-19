function [band, wvfn] = staticlattice(h_kinetic, h_latt, n_qwv, dim)
band = nan(dim, n_qwv);
wvfn = nan(dim, dim, n_qwv);
wvfn_left = nan(dim, dim);
for i_q = 1:n_qwv
    % in real wavevector basis
    H = h_latt + h_kinetic(i_q);
    % V : dim × dim, L : dim × dim
    % Band basis, in real wavevector basis
    [V, L] = eig(H); 
    % dim × 1
    [E, ord_static] = sort(diag(real(L))); 
    V = V(:,ord_static);	
    % detect the 0 or π phase shift of compared to last basis
    % since the static lattice has real matrix elements, the phase shift
    % can only be 0 or π, therefore using round function is sufficient
    phaseshift = tern(i_q == 1, eye(dim), diag(diag(sign(wvfn_left' * V))));
    V = V * phaseshift;
    % Record Data
    band(:,i_q) = E;
    wvfn(:,:,i_q) = V;
    % record the current wavefunction and quasienergy for the next q on the right
    wvfn_left = V;
end