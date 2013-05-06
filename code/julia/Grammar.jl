# grammar julia
using Distributions
abstract Symbol # the abstract type for nonterminal and Terminal
immutable Nonterminal <: Symbol
    symbol::String
end

type Terminal <: Symbol
    symbol::String
    dist::Distribution
end

immutable Production
    lhs::Nonterminal
    lrhs::Symbol
    rrhs
    prob::Float64
    Production(lhs, lrhs::Nonterminal, rrhs::Nonterminal, prob) = new(lhs,lrhs,rrhs,prob)
    Production(lhs, lrhs::Terminal, rrhs::(), prob) = new(lhs,lrhs,(),prob)
end

function eachcnf(lhsKey, rhsKey, g, nt, t)
  
  if beginswith(rhsKey, '[')
    # response rule
      rhsKey = split(rhsKey, ['[', ']'], 0, false)
      mean = eval( parse( "["*rhsKey[1]*"]") )
      covr = eval( parse( "["*rhsKey[3]*"]") )
      if haskey(t, lhsKey)
          lhs = t[lhsKey]
          lhs.dist = MultivariateNormal(mean, covr)
      else
          lhs = Terminal( lhsKey, MultivariateNormal(mean, covr) )
      end
      t[lhsKey] = lhs
      
  else
      # regular rule
      if haskey(nt, lhsKey)
          lhs = nt[lhsKey]
      else
          lhs = Nonterminal( lhsKey )
          nt[lhsKey] = lhs
      end
      rhsKeys = split( rhsKey, ['[',']',' '], 0, false)
      if length( rhsKeys ) == 2
        # Terminal rule
          if haskey(t, rhsKey[1])
              m = t[rhsKey[1]]
          else
              m = Terminal( rhsKeys[1], MultivariateNormal([0.0], eye(1)))
              t[rhsKeys[1]] = m
          end
          p = Production(lhs, m, (), float(rhsKeys[2]))
          add!(g, p)
  
      elseif length( rhsKeys ) == 3
        # nonterminal rule
          if haskey(nt, rhsKeys[1])
              j = nt[rhsKeys[1]]
          else
              j = Nonterminal( rhsKeys[1] )
              nt[rhsKeys[1]] = j
          end
          if haskey(nt, rhsKeys[2])
              k = nt[rhsKeys[2]]
          else
              k = Nonterminal( rhsKeys[2] )
              nt[rhsKeys[2]] = k
          end
          p = Production(lhs, j, k, float(rhsKeys[3]))
          add!(g, p)
      else
          println("grammar error")
          println(cnf)
      end
  end
end

function loadGrammar(file)
    data = readdlm(file, "->")
    data = map(strip, data)
    N = size(data, 1)
    grammar = Set()
    Nonterminals = Dict()
    Terminals = Dict()
    for i in 1:N
      eachcnf(data[i,1], data[i,2], grammar, Nonterminals, Terminals)
    end
    #println("Grammar")
    #for s in grammar
    #    println(s)
    #end
    #println("Terminal")
    #for t in Terminals
    #    println(t)
    #end
    #println("Nonterminal")
    #for n in Nonterminals
    #    println(n)
    #end
    A = {(x.lhs::Nonterminal, x.lrhs::Nonterminal, x.rrhs::Nonterminal) => x.prob for x = filter( y-> isa(y.lrhs, Nonterminal), grammar) }
    B = {(x.lhs::Nonterminal, x.lrhs::Terminal) => x.prob for x = filter( y-> isa(y.lrhs, Terminal), grammar) }
    start = get(Nonterminals, data[1,1], "error")
    return A, B, start 
end


export Nonterminal, Terminal, Production, grammar, Nonterminals, Terminals
