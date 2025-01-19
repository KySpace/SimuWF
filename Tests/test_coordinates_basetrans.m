N = 50; dim = 2*N + 1;
dx = 0.1; G = pi / dx;
R = N * dx; dk = pi / R;
halfsz = [N*dx, 0, 0];
dr = [dx, 1, 1];
coeff = 2*N / (2*N + 1);

% These two generate grid points for position and wavevector
% X range : [-R, R], step dx == π / G
% K range : [-G, G], step dk == π / R
% N == G / dk == R / dx
% site numbers == Hilbert space dimension == (2N + 1) == dim

[X,~,~] = gengridspos(halfsz, dr);
[K,~,~] = gengridsmmt(halfsz, dr);


% We always use fftshift to bring the wavevector range to be symmetric
% aroung 0
fft_x_k = @(v)fftshift(fft(v))/sqrt(dim);
fft_k_x = @(v)ifft(ifftshift(v))*sqrt(dim);



i_k = 1; j_x = 3;
[phi_i, psi_i] = gen_wvfn_free(i_k, X, K, N, R);
[phi_j, psi_j] = gen_wvfn_site(j_x, X, K, N, R);

% By this definition, the fft relation should be consistent
err_i = sum(abs(fft_x_k(psi_i) - phi_i))/dim;
err_j = sum(abs(fft_k_x(phi_j) - psi_j))/dim;

% Therefore, we can write the fft functions as matrix multiplication
K_to_X = exp(  1i * (X + R) * K' * coeff)/sqrt(dim); % [psi_-N ... psi_i ... psi_+N]
X_to_K = exp(- 1i * K * (X' + R) * coeff)/sqrt(dim); % [phi_-N ... phi_j ... phi_+N]

% such that (Examination)
err_conv_i = sum(K_to_X(:,i_k) - psi_i)/dim;
err_conv_j = sum(X_to_K(:,j_x) - phi_j)/dim;
eye_kk = abs(K_to_X * X_to_K); % should be eye(dim)
eye_xx = abs(K_to_X * X_to_K); % should be eye(dim)

% 
op_K_kk = diag(K);
op_X_xx = diag(X);
op_T_kk = op_K_kk .^ 2;
op_V_xx = diag(cos(4*X) - sin(2*X) - cos(X));

op_K_xx = K_to_X * op_K_kk * X_to_K;
op_T_xx = K_to_X * op_T_kk * X_to_K;
op_V_kk = X_to_K * op_V_xx * K_to_X;

function [phi, psi] = gen_wvfn_free(i_k, X, K, N, R)
    coeff = 2*N / (2*N + 1); dim = 2*N + 1;
    phi = zeros([dim 1]); phi(i_k) = 1;
    psi = exp(1i * K(i_k) * (X + R) * coeff)/sqrt(dim);
end

function [phi, psi] = gen_wvfn_site(j_x, X, K, N, R)
    coeff = 2*N / (2*N + 1); dim = 2*N + 1;
    psi = zeros([dim 1]); psi(j_x) = 1;
    phi = exp(- 1i * K * (X(j_x) + R) * coeff)/sqrt(dim);  
end