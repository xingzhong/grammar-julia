include("Grammar.jl")
include("Inside.jl")

TEST = [ ones(14, 1) zeros(14, 1) ]
TEST = TEST + 0.4* randn(14,2)
x = linspace( 0, 3*pi, 15 )
TEST2 = [diff(x) diff(sin(x))]
TEST2 = TEST2 + 0.4* randn(14,2)
x1 = linspace( -5, 5, 8 )
x2 = linspace(5,-5, 8)
TEST3 = [diff(x1) diff( sqrt(36-x1.^2))]
TEST3 = [TEST3; diff(x2) diff( -sqrt(36-x2.^2))]
TEST3 = TEST3 + 0.4* randn(14,2)

#TEST = TEST2
TEST = TEST3
show(TEST)
grammar = "./line.cnf"

A, B, S = loadGrammar(grammar)
println("CYK parsing"*grammar)
GT = CYK(TEST, A, B)
println("Parsing Tree")
loglik = buildTree(GT, S, TEST)
println(loglik)
println()

using Winston
path = cumsum(TEST)
p = FramedPlot("title", string(loglik))
setattr(p, "xrange", (-15,15))
setattr(p, "yrange", (-10,10))
setattr(p, "aspect_ratio", 1)
setattr(p.frame1, "draw_grid", true )
add(p, Points(path[:,1], path[:,2], "symboltype", "half filled triangle"))
add(p, Curve(path[:,1], path[:,2], "linetype", "longdashed"))
file(p, "test.png")