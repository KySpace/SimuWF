classdef FreqSweepShakeBandGenerator < Iterator
    properties (Constant)
        confignames     = []
        paramsnames = ["depth_latt" "max_shake" "ampl_sweep" "freq_sweep" "step_qwv" "hfdim_smpl" "dim" "n_seq" "shake_phase"]
        datanames = ["band_freq_sweep" "wvfn_shake_sbb" "band_shake_sbb" "wvfn_static_rwb" "band_static_rwb" "wvfn_micro_finfreq_sbb" ...
                    "depth_latt" "max_shake" "shake_phase" "ampl_sweep" "freq_sweep" "step_qwv" "i_q_zs" "hfdim_smpl" "dim_smpl" "dim" "n_seq" "qwv_norm"]
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
        depth_latt
        max_shake
        shake_phase         = 0
        ampl_sweep
        freq_sweep
        step_qwv
        hfdim_smpl
        dim
        n_seq
    end
    % deduced
    properties
        qwv_norm
        seq_shake
        n_freq
        n_ramp
        n_qwv
        qwv_offset
        i_q_zs
        dim_smpl    
        Id_smpl
        Id
        % terms of Hamiltonians in real wavevector basis
        H_Kinetic
        H_latt_phase
        H_static
        H_shake 
    end
    % transient properties
    properties
        % for adiabatically transition (at ZS)
        wvfn_zs_last_sbb
        % current amplitude and frequency
        freq_now
        ampl_now
    end
    properties
        % static lattice bands, under the wavevector basis
        band_static_rwb
        wvfn_static_rwb
        % shaken lattice bands, under the static band basis
        % dim_smpl (band index) × n_qwv (wavevector) × (o.n_ramp + o.n_freq)
        band_shake_sbb
        % dim_smpl (basis) × dim_smpl (band index) × n_qwv (wavevector) × (o.n_ramp + o.n_freq)
        wvfn_shake_sbb
        % frequency table
        band_freq_sweep
        % micromotion at the last frequency, in effective basis
        % dim (basis) × dim (band index) × n_seq (evolution) × n_qwv (wavevector)
        wvfn_micro_finfreq_rwb
        wvfn_micro_finfreq_sbb
    end
    methods
        function ready(o) 
            [o.qwv_norm, o.i_q_zs] = gensteptosym(o.step_qwv, 1 + o.step_qwv, 0);
            o.seq_shake = o.max_shake*cos(2*pi*(1:o.n_seq)/o.n_seq);
            o.dim_smpl = 2 * o.hfdim_smpl + 1;
            o.n_ramp = numel(o.ampl_sweep);
            o.n_freq = numel(o.freq_sweep);
            o.n_qwv = numel(o.qwv_norm);
            o.qwv_offset = 2*(-o.hfdim_smpl:o.hfdim_smpl);
            % matrices
            o.Id_smpl = eye(o.dim_smpl);
            o.Id = eye(o.dim);
            o.H_Kinetic = kineticgen(o.qwv_offset, o.qwv_norm); % (q + lG)^2 dispersion
            lattgen = purelattphasemod(o.depth_latt, o.hfdim_smpl);
            o.H_static = lattgen(0);
            o.H_shake = lattgen(o.shake_phase);
            [o.band_static_rwb, o.wvfn_static_rwb] = staticlattice( ...
                o.H_Kinetic, o.H_static, o.n_qwv, o.dim_smpl);
            o.iter_max = o.n_ramp + o.n_freq;
            o.reset();
        end
        function reset(o)
            o.iter_now = 1;
            o.wvfn_zs_last_sbb = o.Id; 
            o.band_shake_sbb = nan([o.dim o.n_qwv o.iter_max]);
            o.wvfn_shake_sbb = nan([o.dim o.dim o.n_qwv o.iter_max]);
            o.band_freq_sweep = nan([o.dim o.n_qwv o.n_freq]);
        end
        function iter(o)
            i_a = tern(o.iter_now > o.n_ramp, o.n_ramp, o.iter_now);
            i_f = tern(o.iter_now > o.n_ramp, o.iter_now - o.n_ramp, 1);
            ampl = o.ampl_sweep(i_a); o.ampl_now = ampl;
            freq = o.freq_sweep(i_f); o.freq_now = freq;
            [band, wvfn, wvfn_micro] = shakenlattice(ampl, 4*freq, o.seq_shake, ...
                o.H_Kinetic, o.H_shake, o.H_static, o.wvfn_static_rwb, o.n_qwv, o.dim);
            % sort band according to last run by zone center correlation
            ord = matchwvfnsets(o.wvfn_zs_last_sbb, wvfn(:,:,o.i_q_zs));
            band_sorted = band(ord, :);
            o.band_shake_sbb(:, :, o.iter_now) = shiftquasibandsbyzs(band_sorted, o.i_q_zs, 4*freq);
            o.wvfn_shake_sbb(:,:,:,o.iter_now) = wvfn(:, ord, :); 
            o.wvfn_zs_last_sbb = o.wvfn_shake_sbb(:,:,o.i_q_zs,o.iter_now);
            % currently only record the final frquency's micromotion
            if o.iter_now == o.iter_max
                o.wvfn_micro_finfreq_sbb = wvfn_micro(:, ord, :, :);
            end
        end
        function wrapup(o)
            o.band_freq_sweep = o.band_shake_sbb(:, :, (o.n_ramp+1):end);
        end
    end
end