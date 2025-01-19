% shift bands to best position by zone center
function band = shiftquasibandsbyzs(band, i_zs, period)
    % shift the ground band to close to 0
    band(1, :) = snapquasibandto(0, band(1, i_zs), period, band(1, :));
    % shift the rest of the bands so that at ZS they are close to the ground band
    band(:, :) = snapquasibandto(band(1, i_zs), band(:, i_zs), period, band);
end