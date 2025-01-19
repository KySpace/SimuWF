bandpath =  readconfiglocal().testrootdir.normal + ...
    "/[2024.07.14].BandGeneration/5.Bands.HighDTrimmed.1/AnalysisOutput";
load(bandpath + "/BandTable.mat");
i_v =  1;
i_f =  40;
i_a =  1 ; shft = [-1; 0];
% i_a =  11 ; shft = 1;
quasi_shft = freq_sweep(i_f)*4;
namer = @(i_v, i_f, i_a) sprintf(bandpath + "/temp/[i_v=%i].[i_f=%i].[i_a=%i].svg", i_v, i_f, i_a);
ax = setaxis(191, "current table view");
q_sample = 1 : 1 : numel(qwv_norm);

band_s = squeeze(quasienergy(i_v,i_a,i_f,1,q_sample))' + shft*quasi_shft;
band_p = squeeze(quasienergy(i_v,i_a,i_f,2,q_sample))' + shft*quasi_shft;


%%
xs = cos(pi*qwv_norm(q_sample));
ys = sin(pi*qwv_norm(q_sample));
shft_band = freq_sweep(i_f)*-0.4;

openax(ax)
l_s = plot3(ax, xs, ys, band_s); 
l_p = plot3(ax, xs, ys, band_p);
shutax(ax)

shutax(ax)
daspect(ax, [1 1 1]);
xlim(ax, [-1.5 1.5]);
ylim(ax, [-1.5 1.5]);
zlim(ax, [-2 4]*freq_sweep(i_f) + shft_band);
ax.Box = "off";
ax.XTick = []; ax.YTick = []; ax.ZTick = [];
view(ax, [48 12]);

%%
openax(ax)

shft_band = freq_sweep(i_f)+-0.4;

for shft_enrg = -2 : 0.4 : 4
l_latitude = plot3(ax, xs, ys, shft_enrg*freq_sweep(i_f)*ones(1, numel(xs)) + shft_band);
l_latitude.Color = [1 1 1] * 0.9;
if mod(shft_enrg, 2) == 0; l_latitude.Color = [2 1 1] * 0.4; end
end
for shft_circ = -1 : 0.2 : 1
x = cos(pi*shft_circ);
y = sin(pi*shft_circ);
l_longitude = plot3(ax, [x x], [y y], [-2 4]*freq_sweep(i_f) + shft_band);
l_longitude.Color = [1 1 1] * 0.9;
if mod(shft_circ, 0.5) == 0; l_longitude.Color = [1 1 1] * 0.4; end
end

shutax(ax)
daspect(ax, [1 1 1]);
xlim(ax, [-1.5 1.5]);
ylim(ax, [-1.5 1.5]);
zlim(ax, [-2 4]*freq_sweep(i_f) + shft_band);
ax.Box = "off";
ax.XTick = []; ax.YTick = []; ax.ZTick = [];
view(ax, [48 12]);

%%
R = 1;
r = 0.6;
shft = -0.6;

[u, v] = meshgrid(linspace(-1,1,20)*pi);
x_uv = (R + r.*cos(u)) .* cos(v);
y_uv =  r * sin(u);
z_uv = (R + r.*cos(u)) .* sin(v);
ax.XTick = []; ax.YTick = []; ax.ZTick = [];

set(ax, "Color", "none");

%%
surf(ax, x_uv, y_uv, z_uv, -abs(u), FaceLighting="gouraud", LineStyle="none", FaceColor="interp", FaceAlpha=0.8);
colormap(ax, "bone");
shading(ax, "interp");
clim(ax, [-5 1]*pi);
ax.XTick = []; ax.YTick = []; ax.ZTick = [];

daspect(ax, [1 1 1]);
view(ax, [60 24]);
xlim(ax, [-1.2,1.2]*(R+r));
ylim(ax, [-1.2,1.2]*r);
zlim(ax, [-1.2,1.2]*(R+r));
set(ax, "Color", "none");
%%

phase_band_s = 2*pi*(band_s/quasi_shft -shft);
phase_qwv = pi*qwv_norm(q_sample);
xs_s = (R + r*cos(phase_qwv)) .* cos(phase_band_s);
ys_s = r * sin(phase_qwv);
zs_s = (R + r*cos(phase_qwv)) .* sin(phase_band_s);

phase_band_p = 2*pi*(band_p/quasi_shft -shft);
phase_qwv = pi*qwv_norm(q_sample);
xs_p = (R + r*cos(phase_qwv)) .* cos(phase_band_p);
ys_p = r * sin(phase_qwv);
zs_p = (R + r*cos(phase_qwv)) .* sin(phase_band_p);

openax(ax)


daspect(ax, [1 1 1]);

l_s = plot3(ax, xs_s, ys_s, zs_s); 
l_p = plot3(ax, xs_p, ys_p, zs_p); 

phi = linspace(0,1,40)*2*pi;
% for i_qen = -1:0.1:1
%     phase_qen = i_qen*pi;
%     xs_phi = (R + r*cos(phase_qen)) .* cos(phi);
%     ys_phi = r * sin(phase_qen) * ones(size(phi));
%     zs_phi = (R + r*cos(phase_qen)) .* sin(phi);
%     l = plot3(ax, xs_phi, ys_phi, zs_phi);
%     l.Color = [1 1 1]*0.8;
%     if mod(i_qen, 0.5) == 0; l.Color = [1 1 1] * 0.4; end
% end
% 
% for i_qwv = -1:0.25:1
%     phase_qwv = i_qwv*pi;
%     xs_phi = (R + r*cos(phi)) .* cos(phase_qwv);
%     ys_phi = r * sin(phi);
%     zs_phi = (R + r*cos(phi)) .* sin(phase_qwv);
%     l = plot3(ax, xs_phi, ys_phi, zs_phi);
%     l.Color = [1 1 1]*0.8;
%     if mod(i_qwv, 0.5) == 0; l.Color = [1 1 1] * 0.4; end
% end

shutax(ax)
ax.XTick = []; ax.YTick = []; ax.ZTick = [];
daspect(ax, [1 1 1]);
view(ax, [60 24]);
xlim(ax, [-1.2,1.2]*(R+r));
ylim(ax, [-1.2,1.2]*r);
zlim(ax, [-1.2,1.2]*(R+r));

%% Static Lattice
hfdim_smpl = 15;
lattgen = purelattphasemod(depth_latt(i_v), hfdim_smpl);
band_static = staticlattice(kineticgen(2*(-hfdim_smpl:hfdim_smpl), qwv_norm(q_sample)), ...
                            lattgen(0), numel(q_sample), 2*hfdim_smpl + 1);
plot(ax, qwv_norm(q_sample), band_static(1:4,:));
xlim(ax, [-1, 1]); ylim(ax, [-2, 18]);
ax.XTick = []; ax.YTick = []; ax.ZTick = [];
%%
shft = [-1;0;1]*quasi_shft;
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
ylim(ax, [-8,8]);
view(ax, [0 90]);
ax.YTick = (-2:1:2)*quasi_shft;
ax.XTick = [-1, 0 1];
ax.XTickLabel = {};
ax.YTickLabel = {};
daspect(ax, [1 2 1]);
ax.Box = "on";
%%

saveas(ax, "Trial.svg")
