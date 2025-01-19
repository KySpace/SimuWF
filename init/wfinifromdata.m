function gen = wfinifromdata(testfolder, testname, dataname, n)
    filename = sprintf("%s\\%s\\%s\\%i.%s.mat", ...
        testrootdir, testfolder, testname, n, dataname);
    load(filename, "saveddata");
    gen = const(saveddata.wf_pos);
end