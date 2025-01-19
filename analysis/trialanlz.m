load d:\\'New folder'\'OneDrive - Georgia Institute of Technology'\LabData\SimuWF\[2022.12.12].ProBandGen\3.CaseLow45.1\5.SimuResult.mat
mask_wf = saveddata.Z > 0;
sz = size(saveddata.Z);
wf_mmt_masked = saveddata.wf_mmt;
wf_mmt_masked(~mask_wf) = 0;
wf_pos_masked = ifftn(ifftshift(wf_mmt_masked));
[~, updaters] = setfigwf(saveddata.pos, saveddata.mmt, wf_pos_masked, [], []);
updaters.mmt(abs(wf_mmt_masked).^2, []);
updaters.pos(abs(wf_pos_masked).^2, []);