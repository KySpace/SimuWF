classdef SimuWF < Iterator
    properties (Constant)
        confignames     = []
        paramsnames     = ["iter_max" "dt_rel" "dr" "halfsz" "pttl_gen" "dsps_gen" "ntrc_gen" "dssp_gen" "wf_ini_gen" "calctime"]
        datanames = ["X" "Y" "Z" "J" "K" "L" "wf_ini" "dt_rel" "dr" "calctime" ...
                     "sz_grid" "Vol" "pos" "mmt" "wf_pos" "wf_mmt" "ts" "E_t" "E_v" "E_i" "E_tot" "dsps" "pttl" "ntrc" "dssp"]
    end
    % runner
    properties
        iter_max  
        iter_now   
        ioupdater   = QueueUnit()
        toproceed   = const(true)
    end
    % settings
    properties
        dt_rel      % relative t step dt / t_R        
        dr
        halfsz
        % (pos | mmt) -> (iter_now -> env)
        pttl_gen
        dsps_gen
        ntrc_gen
        dssp_gen
        wf_ini_gen
        calctime    % time calculator : iter_now -> time
    end
    % deduced
    properties        
        X
        Y
        Z
        J
        K
        L
        % iter_now -> env 
        pttl_t
        dsps_t
        ntrc_t
        dssp_t
        wf_ini
        sz_grid
        Vol
        pos
        mmt
    end
    % transient properties
    properties        
        wf_pos
        wf_mmt
        pttl
        dsps
        ntrc
        dssp
        ts
        E_t
        E_v
        E_i
        E_tot
    end
    methods
        function ready(o); reset(o); end
        function updateenv(o)
            o.pttl = o.pttl_t(o.iter_now);
            o.dsps = o.dsps_t(o.iter_now);
            o.ntrc = o.ntrc_t(o.iter_now);
            o.dssp = o.dssp_t(o.iter_now);
        end
        function reset(o)
            o.iter_now = 1;
            [o.X, o.Y, o.Z] = gengridspos(o.halfsz, o.dr);
            [o.J, o.K, o.L] = gengridsmmt(o.halfsz, o.dr);
            o.pos = [o.X(:) o.Y(:) o.Z(:)]; o.mmt = [o.J(:) o.K(:) o.L(:)];
            o.sz_grid = size(o.X); o.Vol = numel(o.X);
            o.pttl_t = o.pttl_gen(o.X, o.Y, o.Z);
            o.dsps_t = o.dsps_gen(o.J, o.K, o.L);
            o.ntrc_t = o.ntrc_gen;
            o.dssp_t = o.dssp_gen;
            o.updateenv;
            o.wf_ini = o.wf_ini_gen(o.X, o.Y, o.Z);
            o.wf_pos = o.wf_ini;
            o.wf_mmt = fftshift(fftn(o.wf_ini));
            o.ts  = nan([1 o.iter_max]);
            o.E_t = nan([1 o.iter_max]);
            o.E_v = nan([1 o.iter_max]);
            o.E_i = nan([1 o.iter_max]);
            o.E_tot = nan([1 o.iter_max]);
        end
        function iter(o)       
            o.updateenv;
            [o.wf_pos, o.wf_mmt, e_t, e_v, e_i] = ...
                evolve(o.pttl,o.dsps,o.ntrc,o.dssp,o.dt_rel,o.wf_pos);
            o.E_t(o.iter_now) = e_t;
            o.E_v(o.iter_now) = e_v;
            o.E_i(o.iter_now) = e_i;
            o.E_tot(o.iter_now) = o.E_t(o.iter_now) + o.E_v(o.iter_now) + o.E_i(o.iter_now);  
            o.ts(o.iter_now) = o.calctime(o.iter_now);          
        end
        function wrapup(~); end
        function o = SimuWF()
            o.ioupdater = QueueUnit();
        end
    end
end