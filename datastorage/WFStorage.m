classdef WFStorage < DataObserver
    properties (Constant)
        confignames         = []
        paramsnames         = ["sz_dim", "halfsz", "dr", "timestamps", "savename_setter"]
        datanames           = ["sz_dim", "halfsz", "dr", "timestamps", "savename_setter", "savepath", "log"]
    end
    properties
        sz_dim                  % data size for wf (complex number) of each recording
        halfsz
        dr
        timestamps          = []
        savename_setter     % iter_now -> name : string
    end
    properties
        log
    end
    methods
        function recordit = torecord(o, t)
            recordit = sum(t > o.timestamps, "all") > length(o.log);
        end
    end
    % Implementation
    methods
        function init(~); end
        function ready(o, varargin)
            if ~exist(o.savepath, "dir") && ~isempty(o.savepath)
                mkdir(o.savepath);
            end
        end
        function clear(o)
            o.log                   = [];
        end
        function update(o, wf_pos, wf_mmt, t, iter_now)
            if o.torecord(t) 
                if ~isempty(o.savepath)
                    savepath_this = o.savepath + "/" + o.savename_setter(iter_now);
                    save(savepath_this, "wf_pos", "wf_mmt");
                    log_this = struct(  "iter_now", iter_now, ...
                                        "time", t, ...
                                        "path", savepath_this );
                    o.log = [o.log; log_this];
                end
            end
        end
        function final(~); end
        function o = WFStorage()
        end
    end
end