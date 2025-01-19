% [t] -> {a} -> (t -> a)
function gen = piecewiseval(ts, vals)
arguments
    ts    (1,:)     {mustBeInteger}
    vals  cell
end
    if ~isequal(ts, sort(ts))
        eid = 'NonIncreasingTimestamp';
        msg = 'timestamps should be in increasing order';
        throw(MException(['InvalidArgument' eid], msg))
    end
    if ~(numel(ts) == numel(vals))
        eid = 'LengthUnmatched';
        msg = 'timestamps and values do not match';
        throw(MException(['InvalidArgument' eid], msg))
    end
    function field = generator_t(t)
        % Do not expect t < min(ts)
        idx = sum(ts <= t);
        field = vals{idx};
    end
    gen = @generator_t;
end