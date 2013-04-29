# parser julia
using Distributions
include("Grammar.jl")

grammar = Array(Production, 0)
Nonterminals = Array(Nonterminal, 0)
Terminals = Array(Terminal, 0)
S0 = Nonterminal("S0")
S = Nonterminal("S")
A = Nonterminal("A")
B = Nonterminal("B")
a = Terminal("a", MultivariateNormal([0.0, 0.0, 0.0],eye(3)))
b = Terminal("b", MultivariateNormal([1.0, 1.0, 1.0],eye(3)))
push!(Nonterminals, S0)
push!(Nonterminals, S)
push!(Nonterminals, A)
push!(Nonterminals, B)
push!(Terminals, a)
push!(Terminals, b)
push!(grammar, Production(S0, S, A, 1.0))
push!(grammar, Production(S, A, B, 1.0))
push!(grammar, Production(A, A, A, 0.5))
push!(grammar, Production(A, a, (), 0.5))
push!(grammar, Production(B, b, (), 1.0))
println("Grammar")
map(x->println(x), grammar)
A = {(x.lhs::Nonterminal, x.lrhs::Nonterminal, x.rrhs::Nonterminal) => x.prob for x = filter( y-> isa(y.lrhs, Nonterminal), grammar) }
B = {(x.lhs::Nonterminal, x.lrhs::Terminal) => x.prob for x = filter( y-> isa(y.lrhs, Terminal), grammar) }
println("A")
show(A)
println("B")
show(B)

TEST = [0 0 0;0 0 0;1 1 1;0 0 0;0 0 0]
T = size(TEST,1)
show(TEST)

E = Dict{(Int, Int, Nonterminal), Float64}()
println("case 1")
for s in 1:T
    # s == s
    o = vec(TEST[s, :])
    for i in keys(B)
      # i -> m 
      # i == i[1]
      # m == i[2]
      merge!(E, {(s,s,i[1]) => get(B,i,0)*pdf(i[2].dist, o)})
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
              for r in s:t-1 
                  sum += get(A, rule, 0)*get(E, (s,r,rule[2]),0)*get(E, (r+1,t,rule[3]),0)
              end
              #println(s , t, rule, sum)
              if haskey(E, (s,t,rule[1]))
                  println("key error, there are multiple jk for given i")
              else
                  merge!(E, {(s,t,rule[1]) => sum })
              end
            end
        end
    end
end
show(E)
println()
