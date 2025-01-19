% bands dimension : b, q
function plotquasibands(ax, q, bands, E_period) 
    openax(ax)
    l_grnd = plot(ax, q, bands(1,:), '-'); 
    l_main = plot(ax, q, bands(2:end,:), '-', LineWidth=1.5);
    l_shft = plot(ax, q, [bands+E_period; bands-E_period], '-', Color=[0.6 0.6 0.6], LineWidth=0.1);
    l_grnd.LineWidth = 2;
    shutax(ax);
end