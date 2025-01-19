% Shifts a entire band band by multiples of E_period until the desired
% value E_shft is closest to the target value E_ref
function band_snapped = snapquasibandto(E_ref, E_shft, E_period, band)
    band_snapped = band - round((E_shft - E_ref)/E_period)*E_period;
end