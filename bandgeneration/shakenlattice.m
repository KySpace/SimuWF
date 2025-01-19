function [band, wvfn, wvfn_micro] = shakenlattice(ampl, freq, seq_shake, h_kinetic_smpl, h_shake_smpl, h_static_smpl, wvfn_basis_smpl, n_qwv, dim)
    % transform to the given basis and
    % trim the dimension of sample matrices, 
    % keeping only the low energy component
    % dim_smpl × dim_smpl → dim × dim
    function A_trim = trimtrans(A, i_q)
        A_trans = basetransformop(A, wvfn_basis_smpl(:,:,i_q));
        A_trim = A_trans(1:dim, 1:dim);
    end
    % following calculations are done in dimensional dim
    n_seq = numel(seq_shake);
    dt = 2*pi/(freq*n_seq);
    Id = eye(dim);
    band_left = nan([dim 1]);
    band = nan([dim n_qwv]);
    wvfn = nan([dim dim n_qwv]);
    % micromotion in the given basis (static band basis)
    wvfn_micro = nan([dim dim n_seq n_qwv]);
    wvfn_left = nan([dim dim]);
    for i_q = 1:n_qwv    
        Uevo_eff = Id; Uevo_shake = nan([dim dim n_seq]);
        for i_t = 1 : n_seq        
            % the hamiltonian in the real wavevector basis
            S = h_kinetic_smpl(i_q) + ampl*seq_shake(i_t)*h_shake_smpl + h_static_smpl;
            % the hamiltonian in the given basis
            H = trimtrans(S, i_q);
            % Trotter evolution
            Uevo_eff = (Id + 1i*dt*H) * Uevo_eff;
            Uevo_shake(:,:,i_t) = Uevo_eff;
        end
        [V_eff, L_eff] = eig(Uevo_eff);
        
        band_eff = imag(log(-diag(L_eff)));
        wvfn_evo = transformalltime(Uevo_shake, V_eff, n_seq, dim);

        % Maintain the order with the left-most band, continuity
        % start with the static wavefunction ordering    
        wvfn_left = tern(i_q == 1, Id, wvfn_left);    
        wvfn_this = normalizewvfn(V_eff);    
        % ordering aligned with the left q, determined by correlation
        ord = matchwvfnsets(wvfn_left, wvfn_this);
        wvfn_this = wvfn_this(:,ord);
        band_eff = band_eff(ord);
        wvfn_evo = wvfn_evo(:,ord,:);
        % make bands continuous
        band_eff = snapquasineigh(band_left, band_eff, 2*pi);
        % record left value
        wvfn_left = wvfn_this;
        % record data
        band(:,i_q) = band_eff/(2*pi)*freq;
        wvfn(:,:,i_q) = wvfn_this;
        wvfn_micro(:,:,:,i_q) = wvfn_evo;
        band_left = band_eff;
    end
end

function V_o = transformalltime(U_t, wvfn_init, n_seq, dim)
    V_o = nan([dim dim n_seq]);
    for idx_t = 1 : n_seq
        U = squeeze(U_t(:,:, idx_t));
        V_o(:, :, idx_t) = normalizewvfn(U * wvfn_init);
    end
end
