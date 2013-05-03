# parser julia
using Distributions
include("Grammar.jl")
include("Inside.jl")

A, B, S = loadGrammar("./grammar.cnf")

println("A")
show(A)
println("B")
show(B)

#TEST = [1 0 0;0 1 0;0 0 1;1 0.5 0;0 0 1; 0 0.2 -0.3]
#TEST = randn(8,3)
TEST = [0 1.0 0; 1.0 0 0; 0 -1.0 0; -1 0 0]
show(TEST)

#E = inside(TEST, A, B)
Gamma, Tau = CYK(TEST, A, B)
println("Final Gamma")
debug_SortDict(Gamma)
#println("Final Tau")
#debug_SortDict(Tau)
println("parse")
loglik = buildTree(Tau, S, TEST)
println(loglik)
println()
