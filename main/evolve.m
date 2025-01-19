function [wf_pos, wf_mmt, T_tot, V_tot, I_tot] = evolve(potential, dispersion, interaction, dissipation, dt, wf)
    rad_pos = 2 * pi * dt * (potential + interaction * abs(wf).^2);
    wf_pos = (cos(rad_pos) + 1i*sin(rad_pos)) .* exp(- dissipation * rad_pos) .* wf;
    wf_mmt = fftshift(fftn(wf_pos));
    rad_mmt = 2 * pi * dt * dispersion;
    wf_mmt = (cos(rad_mmt) + 1i*sin(rad_mmt)) .* exp(- dissipation * rad_mmt) .* wf_mmt;
    wf_pos = ifftn(ifftshift(wf_mmt));
    scaling = sqrt(sum(abs(wf).^2, "all") / sum(abs(wf_pos).^2, "all"));
    wf_pos = wf_pos * scaling;
    wf_mmt = wf_mmt * scaling;
    V_tot = sum(abs(wf_pos).^2 .* potential, "all");
    T_tot = sum(abs(wf_mmt).^2 .* dispersion, "all") / numel(wf_mmt);
    I_tot = sum(abs(wf_pos).^4 * interaction / 2, "all");
end