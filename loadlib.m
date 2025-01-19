fprintf("loading: SimuWF.\n")

swf_rootpath = fileparts(mfilename("fullpath"));

if ~contains(path, "MatlabFunctional"); run(swf_rootpath + "/[MatlabFunctional]/loadlib"); end
if ~contains(path, "VisualHelper");     run(swf_rootpath + "/[VisualHelpers]/loadlib"); end
if ~contains(path, "TestRunner");       run(swf_rootpath + "/[TestRunner]/loadlib"); end

swf_rootpath = fileparts(mfilename("fullpath"));

swf_srcfolders = ["grids", "tests", "visual", "main", "dispersion", "init", "analysis", "datastorage", "bandgeneration"];
for i = 1 : numel(swf_srcfolders)
    addpath(genpath(swf_rootpath+"/"+swf_srcfolders(i)));
end

clear swf_srcfolders swf_rootpath