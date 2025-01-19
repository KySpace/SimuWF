% analyze left and right center peak
% dens is a 2D density profile
function [moment2_dist_com, moment2_dist_origin, dist_com, deg_com, p, n] = anlzlrc(dens, X, Y)
    dens_p = dens .* (X > 0);
    dens_n = dens .* (X < 0);
    % center of mass
    com_p_x = sum(dens_p .* X, "all") / sum(dens_p, "all");
    com_p_y = sum(dens_p .* Y, "all") / sum(dens_p, "all");
    com_n_x = sum(dens_n .* X, "all") / sum(dens_n, "all");
    com_n_y = sum(dens_n .* Y, "all") / sum(dens_n, "all");
    % concentration to CoM and origin
    distsq_com_p = distsq2d(X - com_p_x, Y - com_p_y);
    distsq_com_n = distsq2d(X - com_n_x, Y - com_n_y);
    distsq_origin = distsq2d(X, Y);
    moment2_dist_com = sqrt(sum(distsq_com_p .* dens_p, "all") + sum(distsq_com_n .* dens_n, "all"));
    moment2_dist_origin = sqrt(sum(distsq_origin .* dens, "all"));
    dist_com = sqrt(distsq2d(com_p_y - com_n_y, com_p_x - com_n_x));
    deg_com = atan2d(com_p_y - com_n_y, com_p_x - com_n_x);
    p = [com_p_x com_p_y];
    n = [com_n_x com_n_y];
end

function d2 = distsq2d(x, y)
    d2 = x.^2 + y.^2;
end