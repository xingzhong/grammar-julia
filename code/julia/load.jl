# julia script
using Winston
type frame
  timestamp::Float64
  feature::Array{Float64, 1}
end

fileName = "../../sample/P1_1_1_p06.csv"
data = readdlm(fileName)
timestamp = data[:, 1]
feature = data[:, 2:]
N = size(feature, 1)
feature = reshape(feature, N, 4, 20)
# feature [ timeindex, xyz, agent#]
println("\nloading data")
Observations = mapslices(diff, feature, 1)
show(Observations)
println()

p1 = FramedPlot()
p2 = FramedPlot()
p3 = FramedPlot()
p4 = FramedPlot()
p = Table(4,1)
add( p1, Curve(timestamp[1:N-1], Observations[:,1,1]))
add( p2, Curve(timestamp[1:N-1], Observations[:,2,1]))
add( p3, Curve(timestamp[1:N-1], Observations[:,3,1]))
add( p4, Curve(timestamp[1:N-1], Observations[:,4,1]))
p[1,1] = p1
p[2,1] = p2
p[3,1] = p3
p[4,1] = p4
file(p, "test.png")
