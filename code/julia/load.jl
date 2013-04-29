# julia script
type frame
  timestamp::Float64
  feature::Array{Float64, 1}
end

fileName = "../../sample/P1_1_1_p06.csv"
data = readdlm(fileName)
time = data[:, 1]
feature = data[:, 2:]
show(feature)
println("\nloading data")
