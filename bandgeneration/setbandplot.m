function [fig, updaters, gobj] = setbandplot(lim, bandgap_freq)
    if ~ishandle(102); fig = figure(102); 
    else
        fig = findall(groot, "Type", "figure", "Number", 102);
        delete(findall(fig, type="annotation")); 
        delete(fig.Children);
    end
    ax = axes(fig);
    ann = annotation(fig, textbox=[0 0 0.3000 0.0600], LineStyle="none", String="step:", FontName="Consolas");

    function updatebands(qwv, freq, bands)
        plotquasibands(ax, qwv, bands, 4*freq);
        ylim(ax, lim);
        xlim([-1,1]);
    end
    
    function updateannotation(iter_now, iter_max, ampl, freq)
        ann.String = sprintf("step: %4i/%4i | ampl : %1.3f | freq = %2.4f (%3.2f Hz)", ...
            iter_now, iter_max, ampl, freq, freq*bandgap_freq);
    end
    
    updaters.bands = @updatebands;
    updaters.ann = @updateannotation;
    gobj = struct();
end