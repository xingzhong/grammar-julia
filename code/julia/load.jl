# julia script
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
show(feature[200:205, :, 7])
