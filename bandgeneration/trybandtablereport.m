clearvars -except bandpath
bandpath = strrep(bandpath, "\", "/");
load(bandpath + "/BandTable.mat");
i_q_zs = (numel(qwv_norm) + 1)/2;

%% Plot and save the bands
namer = @(i_v, i_f, i_a) sprintf(bandpath + "/temp/[i_v=%i].[i_f=%i].[i_a=%i].svg", i_v, i_f, i_a);
ax = setaxis(191, "current table view");
q_sample = 1 : 2 : numel(qwv_norm);
for i_v =  1 : length(depth_latt)
for i_f =  1 : length(freq_sweep)
for i_a =  1 : length(max_shake)
    band_s = squeeze(quasienergy(i_v,i_a,i_f,1,q_sample))' - quasienergy(i_v,i_a,i_f,1,i_q_zs);
    band_p = squeeze(quasienergy(i_v,i_a,i_f,2,q_sample))' - quasienergy(i_v,i_a,i_f,1,i_q_zs);
    % band_l = squeeze(quasienergy(i_v,i_a,i_f,3,x_sample))' - quasienergy(i_v,i_a,i_f,1,i_q_zs);
    shft = [-1;0;1]*4*freq_sweep(i_f);
    openax(ax)
    l_s = plot(ax, qwv_norm(q_sample), band_s + shft); 
    l_p = plot(ax, qwv_norm(q_sample), band_p + shft); 
    % l_l = plot(ax, qwv_norm(x_sample), band_l + shft); 
    l_s(2).Color = [20, 61, 107]/255;    
    for i_l = [1 3]; l_s(i_l).Color = [193, 245, 245]/255; end
    for i_l = 1 : 3
        l_p(i_l).Color = [252, 222, 207]/255; 
        % l_l(i_l).Color = [222, 252, 207]/255; 
    end
    shutax(ax)
    xlim(ax, [-1, 1]);
    ylim(ax, [-2.5,2.5]);
    ax.YTick = [-2, 0, 2];
    ax.XTick = [-1, 0 1];
    ax.XTickLabel = {};
    ax.YTickLabel = {};
    ax.Box = "on";
    saveas(ax, namer(i_v, i_f, i_a), "svg");
end
end
end

%% Generate the table file
var_row = max_shake;
var_col = freq_sweep;

for i_tab = 1:numel(depth_latt)
nodes = xmlread("bandgeneration/bandtabletemplate.html");
n_page = nodes.getChildNodes.item(1);
n_body = n_page.getChildNodes.item(5);
n_table = n_body.appendChild(nodes.createElement("table"));
% col labels
n_collabel = n_table.appendChild(nodes.createElement("tr"));
n_collabel.appendChild(nodes.createElement("th"))...
       .appendChild(nodes.createTextNode("")); 
for i_col = 1 : length(var_col)
    n_collabel.appendChild(nodes.createElement("th"))...
       .appendChild(nodes.createTextNode(sprintf("freq=%f", freq_sweep(i_col)))); 
end
for i_row = 1 : length(var_row)     
    n_row = n_table.appendChild(nodes.createElement("tr"));
    % row labels
    n_row.appendChild(nodes.createElement("th"))...
        .appendChild(nodes.createTextNode(sprintf("ξ_max=%f", max_shake(i_row))));
    for i_col = 1 : length(var_col)
        picname = namer(i_tab, i_col, i_row);
        n_data = n_row.appendChild(nodes.createElement("td"))...
           .appendChild(nodes.createElement("img"));
        n_data.setAttribute("src", picname);
        n_data.setAttribute("width", "200");
    end
end

xmlwrite(sprintf("%s/BandTable.[v_L=%.1f].html", bandpath, depth_latt(i_tab)) , nodes);
end
