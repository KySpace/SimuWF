step_qwv = 0.01;
halfdim = 10;
depth_latt = 2.8*2;
[qwv_norm, i_q_zs] = gensteptosym(step_qwv, 1 + step_qwv, 0);
dim = 2 * halfdim + 1;
n_qwv = numel(qwv_norm);
qwv_offset = 2 * (-halfdim:halfdim);
H_Kinetic = kineticgen(qwv_offset, qwv_norm); % (q + lG)^2 dispersion
lattgen = purelattphasemod(depth_latt, halfdim);
H_static = lattgen(0);
[band_static_rwb, ~] = staticlattice(H_Kinetic, H_static, n_qwv, dim);
plot(qwv_norm, band_static_rwb);
xlim([-1,1]);