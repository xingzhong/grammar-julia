# parser julia
using Distributions
include("Grammar.jl")

grammar = Array(Production, 0)
Nonterminals = Array(Nonterminal, 0)
Terminals = Array(Terminal, 0)

S = Nonterminal("S")
A = Nonterminal("A")
B = Nonterminal("B")
C = Nonterminal("C")
a = Terminal("a", MultivariateNormal([1.0, 0.0, 0.0],eye(3)))
b = Terminal("b", MultivariateNormal([0.0, 1.0, 0.0],eye(3)))
c = Terminal("c", MultivariateNormal([0.0, 0.0, 1.0],eye(3)))

push!(Nonterminals, S)
push!(Nonterminals, A)
push!(Nonterminals, B)
push!(Nonterminals, C)
push!(Terminals, a)
push!(Terminals, b)
push!(Terminals, c)
push!(grammar, Production(S, A, B, 1.0/6))
push!(grammar, Production(S, A, C, 1.0/6))
push!(grammar, Production(S, B, C, 1.0/6))
push!(grammar, Production(S, B, A, 1.0/6))
push!(grammar, Production(S, C, A, 1.0/6))
push!(grammar, Production(S, C, B, 1.0/6))
push!(grammar, Production(A, A, A, 0.33))
push!(grammar, Production(A, A, B, 0.33))
push!(grammar, Production(A, A, C, 0.33))
push!(grammar, Production(B, B, A, 0.33))
push!(grammar, Production(B, B, B, 0.33))
push!(grammar, Production(B, B, C, 0.33))
push!(grammar, Production(C, C, A, 0.33))
push!(grammar, Production(C, C, B, 0.33))
push!(grammar, Production(C, C, C, 0.33))
push!(grammar, Production(A, a, (), 0.01))
push!(grammar, Production(B, b, (), 0.01))
push!(grammar, Production(C, c, (), 0.01))
#println("Grammar")
#map(x->println(x), grammar)

A = {(x.lhs::Nonterminal, x.lrhs::Nonterminal, x.rrhs::Nonterminal) => x.prob for x = filter( y-> isa(y.lrhs, Nonterminal), grammar) }
B = {(x.lhs::Nonterminal, x.lrhs::Terminal) => x.prob for x = filter( y-> isa(y.lrhs, Terminal), grammar) }
#println("A")
#show(A)
#println("B")
#show(B)

TEST = [1 0 0;0 1 0;0 0 1;1 0 0;0 0 1]
#TEST = randn(20,3)
T = size(TEST,1)
#show(TEST)

E = Dict{(Int, Int, Nonterminal), Float64}()
println("case 1")
for s in 1:T
    # s == s
    o = vec(TEST[s, :])
    for rule in keys(B)
      # rule: i -> m 
      i = rule[1]
      m = rule[2]
      b = get(B, rule, 0)
      merge!(E, {(s,s,i) => b * pdf(m.dist, o)})
  end
end

println("case 2")
for dt in 1:T
    for s in 1:T
        t = s + dt
        if t<=T
            for rule in keys(A)
              # rule: i->jk
              sum = 0
              i = rule[1]
              j = rule[2]
              k = rule[3]
              for r in s:t-1 
                  if haskey(A, rule) && haskey(E, (s,r,j)) && haskey(E, (r+1, t, k))
                    sum += get(A, rule, 0) *  get(E, (s,r,j),0) * get(E, (r+1,t,k),0)
                  end
              end
              if haskey(E, (s,t,i))
                  sum += get(E, (s,t,i), 0)
              end
              if sum != 0
                merge!(E, {(s,t,i) => sum })
              end
            end
        end
    end
end
show(get(E, (1, T, S), -1))
println()
