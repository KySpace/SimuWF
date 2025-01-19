function constgen = constgen(gen)
    constgen = @(varargin) const(gen(varargin{:}));
end