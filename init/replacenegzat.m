function replaceneggen = replacenegzat(gen, t_0, val)
    function gen_t = gen_env(X, Y, Z)
        full = gen(X, Y, Z);
        half = full; half(Z < 0) = val;
        gen_t = @(t) ifthel(t > t_0, half, full);
    end
    replaceneggen = @gen_env;
end