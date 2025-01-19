classdef WFPrflStorage < DataObserver
    properties (Constant)
        confignames         = []
        paramsnames         = ["sz_dim", "dr", "dim_integrate", "iter_max"]
        datanames           = ["sz_dim", "dr", "dim_integrate", "iter_max", "timestamps", "sz_prfl", "evo_prfl_pos", "evo_prfl_mmt"]
    end
    properties
        sz_dim
        dr
        dim_integrate         
        iter_max
    end
    properties
        timestamps          
        sz_prfl             % data size for wavefunction profile (real number) of each recording
        evo_prfl_pos        % the stored data
        evo_prfl_mmt        % the stored data
        integrate
    end
    % Implementation
    methods
        function init(~); end
        function ready(o, varargin)
            % calculate the size after integration
            sz_prfl_temp = o.sz_dim;
            for i_d = 1 : numel(o.dim_integrate)
                d_i = o.dim_integrate(i_d);
                sz_prfl_temp(d_i) = 1;
            end
            o.sz_prfl = squeeze(sz_prfl_temp); 
            function prfl = integrate_wf(wf)
                density = abs(wf).^2;
                prfl = sum(density, o.dim_integrate);
            end
            o.integrate = @integrate_wf;
        end
        function clear(o)
            o.evo_prfl_pos = nan([o.iter_max, o.sz_prfl]);
            o.evo_prfl_mmt = nan([o.iter_max, o.sz_prfl]);
            o.timestamps = nan([1 o.iter_max]);
        end
        function update(o, wf_pos, wf_mmt, t, iter_now)            
            prfl_pos = o.integrate(wf_pos);
            prfl_mmt = o.integrate(wf_mmt);
            o.evo_prfl_pos(iter_now, :) = prfl_pos(:);
            o.evo_prfl_mmt(iter_now, :) = prfl_mmt(:);
            o.timestamps(iter_now) = t;
        end
        function final(~)
        end
        function o = WFPrflStorage()
        end
    end
end