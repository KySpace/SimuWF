function [clr, update] = clrx(c, op)
arguments
    c
    op.rad_red       = 0
    op.satur_max     = 1;
    op.value_max     = 1;
    op.amp   {mustBeMember(op.amp, ["satur", "light", "none"])}   = "none"; 
end
    len = numel(c);
    svone = ones([len 1]);
    switch op.amp 
        case "none"
            satur = @(~) op.satur_max * svone;
            light = @(~) op.value_max * svone;
        case "light"
            satur = @(~) op.satur_max * svone;
            light = @(c) op.value_max * ampx(c,"max", 1);
        case "satur"
            satur = @(c) op.satur_max * ampx(c,"max", 1);
            light = @(~) op.value_max * svone;
    end
    update = @(c) updateclr(satur, light, op.rad_red, c);
    clr = update(c);
end

function rgb = updateclr(satur, light, rad_red, c)
    hue = mod(angle(c(:))/2/pi - rad_red, 1);
    rgb = hsl2rgb([hue, satur(c), light(c)]);
end