function f = wfinigauss(mu, sigma)
    function wf = wf(X,Y,Z)
        X_cent = X - mu(1);
        Y_cent = Y - mu(2);
        Z_cent = Z - mu(3);
        Rsq = X_cent.^2 + Y_cent.^2 + Z_cent.^2;
        wf = exp(-Rsq/sigma^2/2);
    end
    f = @wf;
end