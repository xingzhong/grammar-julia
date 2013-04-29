# grammar julia
type Nonterminal
    symbol::String
end
type Terminal
    symbol::String
    dist::Distribution
end

type Production
    lhs::Nonterminal
    lrhs
    rrhs
    prob::Float64
    Production(lhs, lrhs::Nonterminal, rrhs::Nonterminal, prob) = new(lhs,lrhs,rrhs,prob)
    Production(lhs, lrhs::Terminal, rrhs, prob) = new(lhs,lrhs,(),prob)
end
export Nonterminal, Terminal, Production
