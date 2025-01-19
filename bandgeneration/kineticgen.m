function gen = kineticgen(arr_offset, qwv)
    function T = T_gen(i_q)
        T = diag((arr_offset + qwv(i_q)).^2);
    end
    gen = @T_gen;
end