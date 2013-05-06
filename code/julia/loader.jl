# julia module 
# load the dataset into data

immutable Frame
  ti::Array{Int64,1}
  fe::Array{Float64,3}
  ob::Array{Float64,3}
end

function DataMS(fileName)
	raw = readdlm(fileName)
	timestamps = int64(raw[:,1])
	features = raw[:, 2:]
	N = size(features,1)
	features = reshape(features, N, 4, 20)
	nonzeroInd = findfirst(features[:,4,:])
	features = features[nonzeroInd:, 1:3, :]
	observations = mapslices(diff, features, 1)
	return Frame(timestamps, features, observations)
end

export DataMS, Frame