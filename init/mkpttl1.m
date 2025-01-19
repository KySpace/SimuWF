% a common potential configuration with dipole and optical lattice
% The direction of the 0 degree is the direction of lattice
% The dipole trap is at an angle with the lattice
% The dipole traps' intensity is represented by the trap frequencies, directly
% measured by sloshing atoms
% The lattice's intensity is acquired by the deepest lattice depth,
% measured with KD-scattering, and the lattice waist, which should be
% significantly larger than the dipole trap's waist.
function U_rel_gen = mkpttl1(vel_rec, freq_dipl_trsv, freq_dipl_long, deg_dipl, shft_dipl, depth_latt, w_latt_trsv, w_latt_long)
arguments
    vel_rec              % h/(m*lam)
    freq_dipl_trsv
    freq_dipl_long
    deg_dipl
    shft_dipl     (1,3) = [0,0,0]
    depth_latt          = 0
    w_latt_trsv         = 1000;
    w_latt_long         = 1000;
end
    % this calculates the effective trap size with U_max = 1 E_R
    w_dipl_trsv = vel_rec / freq_dipl_trsv / (2*pi);
    w_dipl_long = vel_rec / freq_dipl_long / (2*pi);
    gen_dipl = pttlrotated_XZ(deg_dipl, w_dipl_trsv, w_dipl_long, 1);
    gen_latt = pttlrotated_XZ(0, w_latt_trsv, w_latt_long, depth_latt);
    function pttl = addpttl(X,Y,Z)
        pttl = gen_dipl(X - shft_dipl(1), Y - shft_dipl(2), Z - shft_dipl(3)) ...
                + gen_latt(X,Y,Z);
    end
    U_rel_gen = constgen(@addpttl);
end