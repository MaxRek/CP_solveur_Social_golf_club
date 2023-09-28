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

function difference(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    #cardinalité de F = max peut changer selon le nombre d'éléments dans up
    #min va changer si le nb d'leme dans lb
    
    #lb
    dr.lb = copy(d1.lb)
    dlb = 0 #nombre de retraits dans borne inf
    for i in d2.lb
        j = 1
        stop = false
        while(j<=size(dr.lb)[1] && !stop)    
            if(dr.lb[j]!=i)
                j += 1
            else
                stop = true
                dlb += 1
            end
        end
        if stop
            popat!(dr.lb,j)
        end
    end

    #up
    dr.up = copy(d1.up)
    dup = 0 #nombre de retraits dans borne sup

    for i in d2.up
        j = 1
        stop = false
        while(j<=size(dr.up)[1] && !stop)    
            if(dr.up[j]!=i)
                j += 1
            else
                stop = true
            end
        end
        if stop
            popat!(dr.up,j)
            dup += 1
        end
    end

    #cardinalities
    dr.minC = d1.minC - dlb
    dr.maxC = d1.maxC - dup

    if(dr.minC < size(dr.lb)[1])
        dr.minC = size(dr.lb)[1]
    end
    if(size(elem_array(dr.lb,dr.up))[1]<dr.maxC)
        dr.maxC = size(elem_array(dr.lb,dr.up))[1]
    end
    

    return dr
end


function addUp(d :: Domain, v :: Vector{Int64})
    for j in v
        stop = false
        i = 1
        while(i < size(d.up)[1] && !stop )
            if(d.up[i+1]<j)
                i+=1
            else
                stop = true
            end
        end
        if(!stop)
            append!(d.up,j)
        else
            insert!(d.up,i+1,j)
        end
    end
    return d
end

    
function addLb(d :: Domain, v :: Vector{Int64})
    for j in v
        stop = false
        i = 1
        while(i < size(d.lb)[1] && !stop )
            if(d.lb[i+1]<j)
                i+=1
            else
                stop = true
            end
        end
        if(!stop)
            append!(d.lb,j)
        else
            insert!(d.lb,i+1,j)
        end
    end

    if(size(d.lb)[1]>d.minC)
        d.minC = size(d.lb)[1]
    end
    if( d.minC > d.maxC)
        d.maxC = d.minC
    end

    return d
end

function elem_array(a :: Vector{Int64},b :: Vector{Int64})
    c = copy(a)
    for e in b
        if(!(e in a))
            append!(c,e)
        end
    end
    return c
end