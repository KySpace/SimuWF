function f = wfinigauoval_XZ(mu, sigma, deg)
    function wf = wf(X,Y,Z)
        X_norm = ((X - mu(1))*cosd(deg) - (Z - mu(3))*sind(deg))/sigma(1);
        Z_norm = ((Z - mu(3))*cosd(deg) + (X - mu(1))*sind(deg))/sigma(3);
        Y_norm = (Y - mu(2))/sigma(2);
        Rsq = X_norm.^2 + Y_norm.^2 + Z_norm.^2;
        wf = exp(-Rsq.^2/2);
    end
    f = @wf;
end