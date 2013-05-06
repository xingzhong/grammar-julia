# julia script
using Winston
type frame
  timestamp::Float64
  feature::Array{Float64, 1}
end

include("Grammar.jl")
include("Inside.jl")


fileName = "../../sample/P3_2_8_p02.csv"
data = readdlm(fileName)
timestamp = data[:, 1]
feature = data[:, 2:]
N = size(feature, 1)
feature = reshape(feature, N, 4, 20)
# feature [ timeindex, xyz, agent#]
nonzeroInd = findfirst(feature[:, 4, :])
feature = feature[nonzeroInd:, 1:3, :]

println("\nloading data")
Observations = mapslices(diff, feature, 1)
#show(Observations)
println()
TEST = Observations[150:200, :, 7] # 119
#TEST = Observations[1:155, :, 7] # 128
#show(TEST)
grammar = "./circle.cnf"
A, B, S = loadGrammar(grammar)
#Gamma, Tau = CYK(TEST, A, B)
GT = CYK(TEST, A, B)
#println("Final Gamma")
#debug_SortDict(Gamma)
#println("Final Tau")
#for t in GT
#    println(t)
#end
println("parse")
#loglik = buildTree(Tau, S, TEST)
loglik = buildTree(GT, S, TEST)
println(loglik)
println()

#p1 = FramedPlot()
#p2 = FramedPlot()
#p3 = FramedPlot()
#p = Table(3,1)
#add( p1, Curve(1:size(TEST,1), TEST[:,1,1]))
#add( p2, Curve(1:size(TEST,1), TEST[:,2,1]))
#add( p3, Curve(1:size(TEST,1), TEST[:,3,1]))
#p[1,1] = p1
#p[2,1] = p2
#p[3,1] = p3
#file(p, "test.png")
