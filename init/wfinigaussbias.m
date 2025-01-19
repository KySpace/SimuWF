function f = wfinigaussbias(mu, sigma, k)
    function wf = wf(X,Y,Z)
        X_cent = X - mu(1);
        Y_cent = Y - mu(2);
        Z_cent = Z - mu(3);
        Rsq = X_cent.^2 + Y_cent.^2 + Z_cent.^2;
        wf = exp(-Rsq/sigma^2/2) .* exp(1i*Z*k);
    end
    f = @wf;
end