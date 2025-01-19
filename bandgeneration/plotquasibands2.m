% bands dimension : b, q
function plotquasibands2(ax, q, bands, E_period) 
    openax(ax)
    for i_b = 1 : size(bands, 1)
        shft_bands = repmat(bands(i_b,:), [5, 1]) + (-2:2)'*E_period;
        ls = plot(ax, q, shft_bands, '-'); 
        for i_p = 1 : 5
            l = ls(i_p);
            l.Color = ls(1).Color;
            l.LineWidth = 2;
        end
    end
    shutax(ax);
end