% Snaps a potentially noncontinuous (breaking) quasienergy value E_break 
% to a neighboring value E_ref, by adding multiples of E_period until 
% it's closest to the E_ref
function E_snapped = snapquasineigh(E_ref, E_break, E_period)
    E_ref(isnan(E_ref)) = E_break(isnan(E_ref));
    shft = round((E_break - E_ref)/E_period);
    E_snapped = E_break - shft*E_period;
end