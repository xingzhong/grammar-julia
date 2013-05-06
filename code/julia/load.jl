# julia script
include("loader.jl")
include("Grammar.jl")
include("Inside.jl")

fileName = "../../sample/P3_2_8_p02.csv"
#fileName = "../../sample/P1_1_12_p19.csv"
println("\nloading data "*fileName)
frame = DataMS(fileName)

TEST = frame.ob[150:200, :, 7] # 119
#TEST = Observations[120:155, :, 7] # 128
#show(TEST)
grammar = "./circle.cnf"
#grammar = "./multi_circle.cnf"
A, B, S = loadGrammar(grammar)
println("CYK parsing"*grammar)
Gamma, Tau = CYK(TEST, A, B)

println("Parsing Tree")
loglik = buildTree(Tau, S, TEST)
println(loglik)
println()

