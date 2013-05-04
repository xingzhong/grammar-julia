# grammar julia
type Nonterminal
    symbol::String
end
#function isequal(x::Nonterminal, y::Nonterminal)
#  return x.symbol == y.symbol
#end
type Terminal
    symbol::String
    dist::Distribution
end
#function isequal(x::Terminal, y::Terminal)
#  return x.symbol == y.symbol
#end

type Production
    lhs::Nonterminal
    lrhs
    rrhs
    prob::Float64
    Production(lhs, lrhs::Nonterminal, rrhs::Nonterminal, prob) = new(lhs,lrhs,rrhs,prob)
    Production(lhs, lrhs::Terminal, rrhs, prob) = new(lhs,lrhs,(),prob)
end

function eachcnf(lhsKey, rhsKey, g, nt, t)
  #FIXME need make sure the uniqueness 
  if beginswith(rhsKey, '[')
      rhsKey = split(rhsKey, ['[', ']'], 0, false)
      mean = eval( parse( "["*rhsKey[1]*"]") )
      covr = eval( parse( "["*rhsKey[3]*"]") )
      if haskey(t, lhsKey)
          lhs = get(t, lhsKey, -1)
          println(lhs)
          lhs.dist = MultivariateNormal(mean, covr)
      else
          lhs = Terminal( lhsKey, MultivariateNormal(mean, covr) )
      end
      merge!(t, {lhsKey=>lhs}) 
  else
      if haskey(nt, lhsKey)
          lhs = get(nt, lhsKey, -1)
      else
          lhs = Nonterminal( lhsKey )
          merge!(nt, {lhsKey => lhs})
      end
      rhsKeys = split( rhsKey, ['[',']',' '], 0, false)
      if length( rhsKeys ) == 2
          if haskey(t, rhsKey[1])
              m = get(t, rhsKey[1], -1)
          else
              m = Terminal( rhsKeys[1], MultivariateNormal([0.0,1.0,0.0], [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]) )
              merge!(t, {rhsKeys[1] => m})
          end
          p = Production(lhs, m, (), float(rhsKeys[2]))
          add!(g, p)
  
      elseif length( rhsKeys ) == 3
          if haskey(nt, rhsKeys[1])
              j = get(nt, rhsKeys[1], -1)
          else
              j = Nonterminal( rhsKeys[1] )
              merge!(nt, {rhsKeys[1] => j})
          end
          if haskey(nt, rhsKeys[2])
              k = get(nt, rhsKeys[2], -1)
          else
              k = Nonterminal( rhsKeys[2] )
              merge!(nt, {rhsKeys[2] => k})
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
    println("Grammar")
    for s in grammar
        println(s)
    end
    println("Terminal")
    for t in Terminals
        println(t)
    end
    println("Nonterminal")
    for n in Nonterminals
        println(n)
    end
    A = {(x.lhs::Nonterminal, x.lrhs::Nonterminal, x.rrhs::Nonterminal) => x.prob for x = filter( y-> isa(y.lrhs, Nonterminal), grammar) }
    B = {(x.lhs::Nonterminal, x.lrhs::Terminal) => x.prob for x = filter( y-> isa(y.lrhs, Terminal), grammar) }
    start = get(Nonterminals, data[1,1], "error")
    return A, B, start 
end


export Nonterminal, Terminal, Production, grammar, Nonterminals, Terminals
