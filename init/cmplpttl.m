function f = cmplpttl(pttl_gen, U_max)
    function wf = wf(X,Y,Z)
        wf = sqrt(truncatecond(U_max - pttl_gen(X,Y,Z), 0, Inf));
    end
    f = @wf;
end