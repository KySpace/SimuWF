function gen = pttlrotated_XZ(deg, w_r, w_z, U_0)
    gen = @(X,Y,Z) (((X*cosd(deg)-Z*sind(deg))/w_r).^2+(Y/w_r).^2+((Z*cosd(deg)+X*sind(deg))/w_z).^2)*U_0;
end