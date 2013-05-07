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
println("\nloading data")
#show(TEST)
grammar = "./circle.cnf"
#grammar = "./multi_circle.cnf"
A, B, S = loadGrammar(grammar)
println("CYK parsing"*grammar)
GT = CYK(TEST, A, B)
println("Parsing Tree")
loglik = buildTree(GT, S, TEST)
println(loglik)
println()

