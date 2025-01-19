clear
% arguments
testpath = "D:\New folder\OneDrive - Georgia Institute of Technology\LabData\SimuWF\[2023.01.12].AngleDependence\1.2D.1\";

l = dir(testpath);
load(testpath + "\NaN.SchemeInfo.mat");
schminfo = saveddata;

for idx = 1 : schminfo.n_variation
    framedata_path = sprintf("%s\\%i.SavedFrame.mat", testpath, idx);
    load(framedata_path);
    framedata = saveddata;
    logs = framedata.log;
    for frameidx = 1 : length(logs)
        log_frame = logs(frameidx);
        time = log_frame.time;
        load(log_frame.path);
        framedata = saveddata;
        anlz(idx, frameidx, time, wf_pos, wf_mmt);
    end
end