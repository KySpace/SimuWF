function z = logamp(z, scale)
    amp = log(abs(z)); amp = amp - max(amp(:)) + scale;
    amp(amp < 0) = 0;
    z = amp .* exp(1i * angle(z));
end