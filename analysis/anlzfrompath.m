function anlzfrompath(testpath, anlzframe, logrun, wrapupframes, wrapupall)

load(testpath + "\NaN.SchemeInfo.mat", "saveddata");
schminfo = saveddata;
load(testpath + "\NaN.IdxList.mat", "saveddata");
idxlist = saveddata;
outputpath = sprintf("%s\\AnalysisOutput", testpath);
mkdir(outputpath);

for idx = 1 : schminfo.n_variation
    idx_raw = idxlist(idx);
    framedata_path = sprintf("%s\\%i.SavedFrame.mat", testpath, idx);
    simuresult_path = sprintf("%s\\%i.SimuResult.mat", testpath, idx);
    load(framedata_path, "saveddata");
    framedata = saveddata;
    load(simuresult_path, "saveddata");
    simuresult = saveddata;
    logs = framedata.log;
    logrun(idx, idx_raw, schminfo, length(idxlist), framedata, simuresult, outputpath);
    for frameidx = 1 : length(logs)
        log_frame = logs(frameidx);
        time = log_frame.time;
        load(log_frame.path);        
        executeall(anlzframe, idx, frameidx, time, wf_pos, wf_mmt, framedata, outputpath);
    end
    executeall(wrapupframes, idx, framedata, outputpath);
end
executeall(wrapupall, outputpath);
end