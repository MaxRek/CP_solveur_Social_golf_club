function union(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    println(d2)
    println(d1)
    dr.lb = copy(d1.lb)

    #bounds
    #lower
    bool = false
    notin = Int64[]
    for i in d2.lb
        if(!(i in dr.lb))
            push!(notin,i)
            bool = true
        end
    end

    #Upper
    bool = false
    notin = Int64[]
    dr.up = copy(d1.up)

    for i in d2.up
        if(!(i in dr.up))
            push!(notin,i)
            bool = true
        end
    end

    if(bool)
        dr = addUp(dr,notin)
    end

    #cardinalities
    dr.minC = d1.minC+d2.minC
    dr.maxC = d1.maxC+d2.maxC

    return dr
end

function intersect(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    
    #bounds
    #lower
    e = Int64[]

    for i in d1.lb
        if(i in d2.lb)
            push!(e,i)
        end
    end

    dr.lb = e

    #Upper
    e = Int64[]

    for i in d1.up
        if(i in d2.up)
            push!(e,i)
        end
    end

    dr.up = e

    #cardinalities
    dr.minC = min(d1.minC,d2.minC)
    dr.maxC = min(d1.maxC,d2.maxC)

    return dr
end

function subDomain(d1 :: Domain, d2 :: Domain)
    #Is d1 subDomain of d2 ?
    dr = false
    #verify cardinalities
    if(d1.minC<=d2.minC)
        if(d1.maxC<=d2.maxC)
            if( size(d1.lb)[1] == (size(d2.lb))[1])
                #Checking lower bounds
                bool = true
                i = 1
                while(bool && i <= size(d1.lb)[1] )
                    if( d1.lb[i] == d2.lb[i])
                        i += 1
                    else
                        bool = false
                    end
                end
                #lower bound OK, checking upper bound
                if(bool)
                    i = 1
                    while(bool && i <= size(d1.up)[1])
                        if(d1.up[i] in d2.up)
                            i+=1
                        else
                            bool = false
                        end
                    end
                    if (bool)
                        #upper bound OK, d1 subDomain of d2
                        dr = true
                    end
                end
            end
        end
    end
    
    return dr
end

function addUp(d :: Domain, v :: Vector{Int64})
    d.up = append!(v,d.up)
    d.up = sort(d.up)
    return d
end

    
function addLb(d :: Domain, v :: Vector{Int64})
    d.lb = append!(v,d.lb)
    d.lb = sort(d.lb)
    return d
end
