function [p, update] = plotwfline(ax, coor, wf)
    openax(ax)
    l_r = plot(ax, coor, real(wf(:)));
    l_i = plot(ax, coor, imag(wf(:)));
    shutax(ax)
    p = [l_r, l_i];
    update = @(wf) updateplot(l_r, l_i, wf);
end

function updateplot(l_r, l_i, wf)
    l_r.YData = real(wf);
    l_i.YData = imag(wf);
end