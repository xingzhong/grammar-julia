# inside probability julia

function inside( O, A, B )
  # O Observation
  E = Dict{(Int, Int, Nonterminal), Float64}()
  T = size(O, 1)
  # init 
  for s in 1:T
      # s == s
      o = vec(O[s, :])
      for rule in keys(B)
        # rule: i -> m 
        i = rule[1]
        m = rule[2]
        b = get(B, rule, 0)
        merge!(E, {(s,s,i) => b * pdf(m.dist, o)})
    end
  end
  
  # bottom-up
  for dt in 1:T
    for s in 1:T
        t = s + dt
        if t<=T
            for rule in keys(A)
              # rule: i->jk
              sum = 0
              i = rule[1]
              j = rule[2]
              k = rule[3]
              for r in s:t-1 
                  if haskey(A, rule) && haskey(E, (s,r,j)) && haskey(E, (r+1, t, k))
                    sum += get(A, rule, 0) *  get(E, (s,r,j),0) * get(E, (r+1,t,k),0)
                  end
              end
              if haskey(E, (s,t,i))
                  sum += get(E, (s,t,i), 0)
              end
              if sum != 0
                merge!(E, {(s,t,i) => sum })
              end
            end
        end
    end
  end
  return E
end


function CYK(O, A, B)
  # CYK chart parsing 
  # O Observation
  # A and B defined the grammar

  Gamma = Dict{(Int, Int, Nonterminal), Float64}()
  Tau = Dict{(Int, Int, Nonterminal), (Nonterminal, Nonterminal, Nonterminal)}()
  T = size(O, 1)
  # init 

  for s in 1:T
      o = vec(O[s, :])
      for rule in keys(B)
        # rule: i -> m 
        i = rule[1]
        m = rule[2]
        b = get(B, rule, 0)
        merge!(Gamma, {(s,s,i) => log(b) + logpdf(m.dist, o)})
      end
  end
  # bottom-up
  for dt in 1:T
    for s in 1:T
        t = s + dt
        if t<=T
            for rule in keys(A)
              # rule: i->jk
              max_g = Dict()
              i = rule[1]
              j = rule[2]
              k = rule[3]
              for r in s:t-1 
                  if haskey(A, rule) && haskey(Gamma, (s,r,j)) && haskey(Gamma, (r+1, t, k))
                    merge!( max_g,  {rule => log(get(A, rule, 0)) +  get(Gamma, (s,r,j),0) + get(Gamma, (r+1,t,k),0)} )
                  end
              end
              if haskey(Gamma, (s,t,i))
                  merge!( max_g, {get(Tau, (s,t,i), (0,0,0)) => get(Gamma, (s,t,i), 0)} )
              end
              if length(max_g) != 0
                  println(max_g)
                  maxg = max(max_g)
                  merge!(Gamma, {(s,t,i) => maxg[2] })
                  merge!(Tau, {(s,t,i) => maxg[1] })
              end
            end
        end
    end
  end

  return Gamma, Tau
end
