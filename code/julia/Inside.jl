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

function debug_SortDict(D)
  G = collect(D)
  indx = sortperm([g[1][1]-g[1][2] for g in G])
  map(x->println(G[x]), indx)
end

function CYK(O, A, B)
  # CYK chart parsing 
  # O Observation
  # A and B defined the grammar

  GT = Dict{(Int, Int, Nonterminal), (Float64, Union((Int, Nonterminal, Nonterminal), String))}()
  T = size(O, 1)
  # init 

  for s=1:T
      o = vec(O[s, :])
      pmap (x->begin
                GT[(s,s,x[1])] = (log(get(B,x,0)) + logpdf(x[2].dist, o), x[2].symbol)
              end, collect(keys(B)))
  end

  #println("Init Gamma")
  #debug_SortDict(GT)
  # bottom-up
  for dt in 1:T
    @printf(STDOUT, "\r%.2f%%", 100*dt/T)
    for s=1:T
        t = s + dt
        if t<=T
            for rule in keys(A)
              # rule: i->jk
              max_g = Dict{(Int, Nonterminal, Nonterminal), Float64}()
              i = rule[1]
              j = rule[2]
              k = rule[3]
              for r in s:t-1 
                  #println((s,t,r,rule))
                  #println((s,r,j, haskey(Gamma, (s,r,j))))
                  #println((r+1,t,k, haskey(Gamma, (r+1,t,k))))
                  if haskey(A, rule) && haskey(GT, (s,r,j)) && haskey(GT, (r+1, t, k))
                    max_g[(r, rule[2], rule[3])] = log(get(A, rule, 0)) +  get(GT, (s,r,j),0)[1] + get(GT, (r+1,t,k),0)[1]
                    #println((s,r,j,k,rule))
                  end
              end
              if haskey(GT, (s,t,i))
                  key = get(GT, (s,t,i), "error")
                  max_g[key[2]]= get(GT, (s,t,i), 0)[1]
              end
              if length(max_g) != 0
                  maxg = maxdict(max_g)
                  GT[(s,t,i)] = (maxg[2], maxg[1])
              end
          end
        end
    end
  end
  return GT
end

function _buildTree(key, value::String, tau)
    #println((key, value))
    tmp = @sprintf("[%s(%d) %s_%s]", key[3].symbol, key[1], value, key[1])
    print(tmp)
end
function _buildTree(key, value::(Int, Nonterminal, Nonterminal), tau)
    #println((key, value))
    tmp = @sprintf("[%s(%d:%d) ", key[3].symbol, key[1], key[2])
    print(tmp)
    left_key = (key[1], value[1], value[2])
    right_key = (value[1]+1, key[2], value[3])
    left = get(tau, left_key, "error")
    right = get(tau, right_key, "error")
    _buildTree(left_key, left[2], tau)
    _buildTree(right_key, right[2], tau)
    print("]")
end
function buildTree(GT, start, O)
  T = size(O, 1)
  root = get(GT, (1,T,start), "error")
  _buildTree((1,T,start), root[2], GT)
  return get(GT, (1,T,start), "-inf")[1]
end

function maxdict(d)
        maxi = -1000
        maxid = 0
        for dd in d 
            if dd[2] > maxi
                maxi = dd[2]
                maxid = dd[1]
            end
        end
        return (maxid, maxi)
end
