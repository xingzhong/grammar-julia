using Clustering
using Winston

include("loader.jl")
fileName = "../../sample/P3_2_8_p02.csv"
#fileName = "../../sample/P1_1_12_p19.csv"
println("\nloading data "*fileName)
frame = DataMS(fileName)
test = transpose(frame.ob[:, 1:2, 7])
#test = randn(2, 500)
res = kmeans(test, 4)
show(res.assignments)
show(Points(res.centers[1,:], res.centers[2,:]))
p = FramedPlot()
data = Points(test[1,:], test[2,:], "type", "circle", "symbolsize", "0.5")
setattr(data, "label", "data")
label = Points(res.centers[1,:], res.centers[2,:], "type", "filled circle", "color", "red")
setattr(data, "label", "label")

add(p, data)
add(p, label)
file(p, "kmean.png")
