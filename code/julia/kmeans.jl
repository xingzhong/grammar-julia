using Clustering
#using Winston


include("loader.jl")
fileName = "../../sample/P3_2_8_p02.csv"
#fileName = "../../sample/P1_1_12_p19.csv"
println("\nloading data "*fileName)
frame = DataMS(fileName)
test = transpose(frame.ob[:, 1:2, 7])
#test = randn(2, 500)
res = kmeans(test, 4)
tokens = res.assignments
d = Dict()
for idx in 2:length(tokens)
  key = (tokens[idx-1], tokens[idx])
  d[key] = get(d, key, 0) + 1
end

relation = Array(Int, 4, 4)
for (k,v) in d 
    relation[k[1], k[2]] = v
end

show (relation)
rule = Dict(1:4, mapslices(indmax, relation, 1))

tokens2 = Array(Int, 0)
ind = 1
while ind < length(tokens) -1
  push!(tokens2, tokens[ind])
  if ( rule[tokens[ind]] == tokens[ind+1] )
      ind += 1
  end
  ind+=1
end

println()
