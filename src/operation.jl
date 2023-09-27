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

    dr.minC = d1.minC+d2.minC
    dr.maxC = d1.maxC+d2.maxC
    return dr
end

function intersect(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    
    return dr
end

function subDomain(d1 :: Domain, d2 :: Domain)
    dr = false
    
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