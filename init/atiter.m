% t -> (pos -> (t -> a)) -> (pos -> a)
function gen_t = atiter(t, gen)
    gen_t = @(varargin) apply(gen(varargin{:}),t);
end