include("Grammar.jl")
include("Inside.jl")
using Winston

TEST1 = [ ones(14, 1) zeros(14, 1) ]
TEST1 = TEST1 + 0.4* randn(14,2)
x = linspace( 0, 3*pi, 15 )
TEST2 = [diff(x) diff(sin(x))]
TEST2 = TEST2 + 0.4* randn(14,2)
x1 = linspace( -5, 5, 8 )
x2 = linspace(5,-5, 8)
TEST3 = [diff(x1) diff( sqrt(36-x1.^2))]
TEST3 = [TEST3; diff(x2) diff( -sqrt(36-x2.^2))]
TEST3 = TEST3 + 0.4* randn(14,2)

#TEST = TEST2
TEST = Array(Matrix, 0)
for i in 1:100
	push!(TEST, randn(10, 2))
end

#show(TEST)
grammar = "./line.cnf"

A, B, S = loadGrammar(grammar)
println("CYK parsing"*grammar)

function evalulate( sequence, a, b, s)
	#println("eval")
	#show(sequence)
	GT = CYK(sequence, a, b)
	loglik = buildTree(GT, s, sequence)
	return (loglik)	
end

liks = map(x->evalulate(x, A,B,S), TEST)
idx = indmax(liks)

path = cumsum(TEST[idx])
p = FramedPlot("title", string(liks[idx]))
setattr(p, "aspect_ratio", 1)
setattr(p.frame1, "draw_grid", true )
add(p, Points(path[:,1], path[:,2], "symboltype", "half filled triangle"))
add(p, Curve(path[:,1], path[:,2], "linetype", "longdashed"))
file(p, grammar*".png")