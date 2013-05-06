# julia script
include("loader.jl")
include("Grammar.jl")
include("Inside.jl")

#fileName = "../../sample/P3_2_8_p02.csv"
println("\nloading data")
fileName = "../../sample/P1_1_12_p19.csv"
frame = DataMS(fileName)

TEST = frame.ob[150:200, :, 7] # 119
#TEST = Observations[120:155, :, 7] # 128
show(TEST)
grammar = "./circle.cnf"
A, B, S = loadGrammar(grammar)
Gamma, Tau = CYK(TEST, A, B)
#println("Final Gamma")
#debug_SortDict(Gamma)
#println("Final Tau")
#for t in Tau
#    println(t)
#end
println("parse")
loglik = buildTree(Tau, S, TEST)
println(loglik)
println()

p1 = FramedPlot()
p2 = FramedPlot()
p3 = FramedPlot()
p = Table(3,1)
add( p1, Curve(1:size(TEST,1), TEST[:,1,1]))
add( p2, Curve(1:size(TEST,1), TEST[:,2,1]))
add( p3, Curve(1:size(TEST,1), TEST[:,3,1]))
p[1,1] = p1
p[2,1] = p2
p[3,1] = p3
file(p, "test.png")
