% [t] -> {(pos|mmt) -> a} -> ((pos|mmt) -> (t -> a))
function gen = piecewisegen(ts, gens)
arguments
    ts    (1,:)     {mustBeInteger}
    gens            {mustBeFunctionHandleCell}
end
    if ~isequal(ts, sort(ts))
        eid = 'NonIncreasingTimestamp';
        msg = 'timestamps should be in increasing order';
        throw(MException(['InvalidArgument' eid], msg))
    end
    if ~(numel(ts) == numel(gens))
        eid = 'LengthUnmatched';
        msg = 'timestamps and generators do not match';
        throw(MException(['InvalidArgument' eid], msg))
    end
    function gen_t = generator_posmmt(varargin)
        fields = apply_c(gens, varargin{:});
        function field = generator_t(t)
            % Do not expect t < min(ts)
            idx = sum(ts <= t);
            field = fields{idx};
        end
        gen_t = @generator_t;
    end
    gen = @generator_posmmt;
end