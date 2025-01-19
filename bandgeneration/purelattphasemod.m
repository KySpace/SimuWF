% Definition: V(x) = V cos(2π X ± ph)
% returns a generator of lattice matrix in wavevector space by given phase
function phasemod = purelattphasemod(V, halfdim)
    U = V/2 * diag(ones(1,halfdim*2),+1);
    L = V/2 * diag(ones(1,halfdim*2),-1);
    phasemod = @(ph) exp(-1i*ph) * U + exp(+1i*ph) * L;
end