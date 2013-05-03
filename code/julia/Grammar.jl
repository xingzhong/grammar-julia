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

function eachcnf(lhs, rhs, g, nt, t)
  #FIXME need make sure the uniqueness 
  lhs = Nonterminal( lhs )
  rhs = split( rhs, ['[',']',' '], 0, false)
  if length( rhs ) == 2
      m = Terminal( rhs[1], MultivariateNormal([0.0,1.0,0.0], eye(3)) )
      p = Production(lhs, m, (), float(rhs[2]))
      add!(nt, lhs)
      add!(t, m)
      add!(g, p)
  elseif length( rhs ) == 3
      j = Nonterminal( rhs[1] )
      k = Nonterminal( rhs[2] )
      p = Production(lhs, j, k, float(rhs[3]))
      add!(nt, lhs)
      add!(nt, j)
      add!(nt, k)
      add!(g, p)
  else
      println("grammar error")
      println(cnf)
  end
end

function loadGrammar(file)
    data = readdlm(file, "->")
    data = map(strip, data)
    N = size(data, 1)
    grammar = Set()
    Nonterminals = Set()
    Terminals = Set()
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
    start = Nonterminal ( data[1,1] )
    return A, B, start 
end


export Nonterminal, Terminal, Production, grammar, Nonterminals, Terminals
