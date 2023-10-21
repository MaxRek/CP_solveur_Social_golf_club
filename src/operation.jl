function union_domain(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    #println("d1 = ",d1,"\nd2 = ",d2)
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

    if(bool)
        addLb(dr,notin)
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
        addUp(dr,notin)
    end

    for i in dr.lb
        j = 1
        stop = false
        while(j<=size(dr.up)[1] && !stop)    
            if(dr.up[j]!=i)
                j += 1
            else
                stop = true
            end
        end
        if(stop)
            popat!(dr.up,j)
        end
    end

    #cardinalities
    union_cardinalities(d1,d2,dr)

    return dr
end

function intersect_domain(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    #println("d1 = ",d1,"\nd2 = ",d2)
    

    #bounds
    #lower
    e = Int64[]

    for i in d1.lb
        if(i in d2.lb || i in d2.up)
            push!(e,i)
        end
    end

    for i in d2.lb
        if(i in d1.up)
            push!(e,i)
        end
    end

    dr.lb = e

    #Upper
    e = Int64[]

    for i in d1.up
        if(i in d2.up && !(i in dr.lb))
            push!(e,i)
        end
    end

    dr.up = e

    #cardinalities
    intersect_cardinalities(d1,d2,dr)

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

function difference_domain(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    e = Vector{Int64}()
    
    for i in d1.lb 
        if(!(i in d2.lb) && !(i in d2.up))
            append!(e,i)
        end
    end

    for i in d2.lb
        if(!(i in d1.lb) && !(i in d1.up)) 
            append!(e,i)
        end
    end

    println("difference_domain\nlb, e = ",e)
    addLb(dr,e)

    e = Vector{Int64}()

    for i in d1.up
        if(!(i in d2.lb) && !(i in d2.up))
            append!(e,i)
        end
    end

    for i in d2.up
        if(!(i in d1.lb) && !(i in d1.up)) 
            append!(e,i)
        end
    end

    println("difference_domain\nup, e = ",e)
    addUp(dr, e)

    difference_cardinalities(d1,d2,dr)

    return dr
end

function old_difference_domain(d1 :: Domain, d2 :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    #cardinalité de F = max peut changer selon le nombre d'éléments dans up
    #min va changer si le nb d'leme dans lb
    #println("d1 = ",d1,"\nd2 = ",d2)
    #lb
    dr.lb = copy(d1.lb)
    e = Vector{Int64}()

    for i in d2.lb
        j = 1
        stop = false
        while(j<=size(dr.lb)[1] && !stop)    
            if(dr.lb[j]!=i)
                j += 1
            else
                stop = true
            end
        end
        if stop
            popat!(dr.lb,j)
        else
            append!(e,i)
        end

    end

    println("----lb----\nd1 = ",d1,"\nd2 = ",d2,"\ndr = ",dr,"\ne = ",e, ", size(e)[1] = ",size(e)[1])
    if(size(e)[1] != 0)
        addLb(dr,e)
    end

    #up
    dr.up = copy(d1.up)
    e = Vector{Int64}()

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
        else
            append!(e,i)
        end
    end

    for i in dr.up
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
        end
    end

    println("----up----\nd1 = ",d1,"\nd2 = ",d2,"\ndr = ",dr,"\ne = ",e, ", size(e)[1] = ",size(e)[1])


    if(size(e)[1] != 0)
        addUp(dr,e)
    end

    #cardinalities
    difference_cardinalities(d1,d2,dr)

    return dr
end

function compare_domain(d1 :: Domain, d2 :: Domain)
    #is d1 == to d2 ?
    dr = false
    #println("d1.minC == ",d1.minC,", d2.minC = ",d2.minC,", d1.maxC = ", d1.maxC,", d2.maxC = ",d2.maxC)
    if(d1.minC == d2.minC)
        if(d1.maxC == d2.maxC)
            #println("size(d1.lb)[1] = ", size(d1.lb)[1], ", size(d2.lb)[1] = ",size(d2.lb)[1],", size(d1.up)[1] = ",size(d1.up)[1],", size(d2.up)[1] = ",size(d2.up)[1])
            if(size(d1.lb)[1] == size(d2.lb)[1] && size(d1.up)[1] == size(d2.up)[1])
                    stop = false
                    j = 1

                    while(j<=size(d1.lb)[1] && !stop)
                        if(d1.lb[j] == d2.lb[j])
                            j += 1
                        else
                            stop = true
                        end
                    end
                    j = 1
                    while(j<=size(d1.up)[1] && !stop)
                        if(d1.up[j] == d2.up[j])
                            j += 1
                        else
                            stop = true
                        end
                    end
                    if(!stop)
                        dr = true
                    end
            end
        end 
    end

    return dr
end

function addUp(d :: Domain, v :: Vector{Int64})
    for j in v
        if(!(j in d.up)&&!(j in d.lb))
            if(size(d.up)[1]!=0)
                if(j>d.up[1])
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
                else
                    insert!(d.up,1,j)
                end
            else
                append!(d.up,j)
            end
        end
    end
end
    
function addLb(d :: Domain, v :: Vector{Int64})
    for j in v
        if(!(j in d.lb))
            if(size(d.lb)[1]!=0)
                #println("j =  ",j,", d.lb = ",d.lb[1]," ")
                if(j>d.lb[1])
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
                else
                    insert!(d.lb,1,j)
                end
            else
                append!(d.lb,j)
            end
        end
    end
end

function del(d :: Domain, v :: Vector{Int64})
    for j in v
        if(j in d.lb)
            if(j>d.up[1])
                stop = false
                i = 1
                while(i < size(d.up)[1] && !stop )
                    if(d.up[i+1]<j)
                        i+=1
                    else
                        stop = true
                    end
                end
                if(stop)
                    popat!(d.up,j)
                end
            else
                insert!(d.up,1,j)
            end
        else
            if(j in d.up)
            end
        end
    end
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

function union_cardinalities(d1 :: Domain, d2 :: Domain, dr :: Domain)
    e1lb = d1.minC - size(d1.lb)[1] ; e2lb = d2.minC - size(d2.lb)[1]
    dr.minC = size(dr.lb)[1] + e1lb + e2lb
    #println("Union_cardinalities\nd1 = ", d1,"\nd2 = ",d2,"\ndr = ",dr)

    e1up = d1.maxC - d1.minC ; e2up = d2.maxC - d2.minC 
    #println("size(dr.up)[1] = ",size(dr.up)[1], ", e1lb = ",e1lb,", e2lb = ",e2lb, ", e1up = ",e1up,", e2up = ",e2up)
    dr.maxC = d1.maxC + d2.maxC 

    e = size(elem_array(dr.lb,dr.up))[1]
    #println("e = ",e,", dr.maxC = ",dr.maxC,"\n________________")
    if(e<dr.maxC)
        dr.maxC = e
        if(dr.maxC<dr.minC)
            dr.minC = dr.maxC
        end
    end
end

function intersect_cardinalities(d1 :: Domain, d2 :: Domain, dr :: Domain)
    dr.minC = max(d1.minC,d2.minC)
    dr.maxC = min(d1.maxC,d2.maxC)

    e = size(elem_array(dr.lb,dr.up))[1]
    #print("e = ",e,", dr.maxC = ",dr.maxC)
    if(e<dr.maxC)
        dr.maxC = e
        if(dr.maxC<dr.minC)
            dr.minC = dr.maxC
        end
    end
end

function difference_cardinalities(d1 :: Domain, d2 :: Domain, dr :: Domain)
    dr.minC = min(d1.minC,d2.minC)
    dr.maxC = max(d1.maxC,d2.maxC)

    e = size(elem_array(dr.lb,dr.up))[1]
    #print("e = ",e,", dr.maxC = ",dr.maxC)
    if(e<dr.maxC)
        dr.maxC = e
        if(dr.maxC<dr.minC)
            dr.minC = dr.maxC
        end
    end
end