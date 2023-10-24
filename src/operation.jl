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
    elb = Int64[]
    eup = Int64[]
    
    for i in d1.lb
        if(i in d2.lb)
            push!(elb,i)
        else
            if(i in d2.up)
                push!(eup,i)
            end
        end
    end

    addLb(dr,elb)
    addUp(dr,eup)

    eup = Int64[]

    for i in d2.lb
        if(i in d1.up && !(i in dr.lb))
            push!(eup,i)
        end
    end

    addUp(dr,eup)
    eup = Int64[]

    for i in d1.up
        if(i in d2.up && !(i in dr.up))
            push!(eup,i) 
        end
    end

    addUp(dr,eup)

    #cardinalities
    intersect_cardinalities(d1,d2,dr)

    return dr
end

function subDomain(io, v :: Int64, d1 :: Domain, d2 :: Domain)
    bool = false
    #d1 sous domaine de d2 ?
    #filtrage de d1 pour n'avoir que les éléments de d2
    d1f = subDomain_filtrage(io, d1,d2)
    dr = intersect_domain(d1f,d2)
    
    # if(v == 1)
    #     print_domain(io, 1, [d1,d2,dr])
    #     println(io, "d1f = ", d1f)
    # else
    #     print_domain(0, 0, [d1,d2,dr])
    #     println("d1f = ", d1f)
    # end

    if (compare_domain(dr,d1f))
        if(size(elem_array(d1f.lb,d1f.up))[1]<d1.minC)
            #println(io,"Pas assez d'éléments dans l'intersection de d1 et d2 pour respecter le domaine de base")
        else
            bool = true
        end
    end
    
    return bool
end

function subDomain_filtrage(io, d1 :: Domain, d2 :: Domain)
    dr = deepcopy(d1)
    e = elem_array(d2.lb,d2.up)

    for i in d1.up
        if(!(i in e))
            del(dr,[i])
        end
    end

    for i in d2.lb
        if(i in dr.up)
            del(dr,[i])
            addLb(dr,[i])
        end
    end

    dr.minC = size(dr.lb)[1]

    e = size(elem_array(dr.lb,dr.up))[1]
    #println("e = ",e,", dr.maxC = ",dr.maxC,"\n________________")
    if(e<dr.maxC)
        dr.maxC = e
        if(dr.maxC<dr.minC)
            dr.minC = dr.maxC
        end
    end

    return dr

end

function old_subDomain(d1 :: Domain, d2 :: Domain)
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
    elb = Vector{Int64}()
    eup = Vector{Int64}()

    
    for i in d1.lb 
        if(!(i in d2.lb))
            if(!(i in d2.up))
                append!(elb,i)
            else
                append!(eup,i)
            end
        end
    end

    addLb(dr, elb)
    addUp(dr, eup)

    elb = Vector{Int64}()
    eup = Vector{Int64}()

    for i in d2.lb
        if(!(i in d1.lb)) 
            if(!(i in d1.up && !(i in dr.lb)))
                append!(elb,i)
            else
                if(!(i in dr.up))
                    append!(eup,i)
                end
            end
        end
    end

    #println("difference_domain\nlb, e = ",e)
    addLb(dr,elb)
    addUp(dr, eup)


    eup = Vector{Int64}()

    for i in d1.up
        if(!(i in dr.up))
            append!(eup,i)
        end
    end

    for i in d2.up
        if(!(i in dr.up)) 
            append!(eup,i)
        end
    end

    #println("difference_domain\nup, e = ",e)
    addUp(dr, eup)

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
    dr.minC = size(dr.lb)[1]
    dr.maxC = size(dr.up)[1]+dr.minC

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
    println("dr = ",dr)
    dr.minC = size(dr.lb)[1]
    dr.maxC = size(dr.up)[1]+dr.minC

    e = size(elem_array(dr.lb,dr.up))[1]
    #print("e = ",e,", dr.maxC = ",dr.maxC)
    if(e<dr.maxC)
        dr.maxC = e
        if(dr.maxC<dr.minC)
            dr.minC = dr.maxC
        end
    end
end