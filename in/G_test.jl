# function propagate(D,F) -> D
#   G <- null
#   while F != null
#       F <- F\{fi}                 #select a function, remove if from faire
#       G <- G U {fi}               #add it to F
#       D' <- fi(D)                 #filter domains with fi
#       F <- F U G' and G <- G/G'
#           where pour chq g dans G, il existe un xk appartenant à var(g), D'k != Dk -> g appartient à G'
#               #functions whose at least one variable has been modified must be woken

function propagation(io, v :: Int64,P :: CSP)
    if(v == 1)
        println(io,"__________\n Propagation \n__________")
    end
    changed = true
    while (changed)
        changed = false
        for c in P.C
            changed = (changed || filtrate(io, P.D[c.domains],c))
        end
    end
end

function filtrate(io, D :: Vector{Domain}, c :: Constraint)
    changed = false  
    if(c.operande == "union")
        changed = filtrate_union(io, D, c)
    else
        if (c.operande == "intersect")
            changed = filtrate_intersection(io, D, c)
        else
            if (c.operande == "subdomain")
                changed = filtrate_subDomain(io, D, c)
            end
        end
    end
    return changed
end

function filtrate_union(io, D :: Vector{Domain}, c :: Constraint)
    changed = false  
    dtest = union_domain(D[1],D[2])
    for i in 3:length(D)
        dtest = union_domain(dtest,D[i])
    end 

    # for i in D
    #     for j in i.up
    #         elementArray = filter( x -> x == j, c.result.up )
    #         if length(elementArray) == 0
    #             i.up = filter!(e->e≠j,i.up)
    #             changed = true
    #         end
    #     end
    # end

    for i in D
        for j in i.up
            elementArray = filter( x -> x == j, c.result.up)
            nbI = length(elementArray)
            elementArray = filter( x -> x == j, c.result.lb)
            nbI += length(elementArray)
            if nbI == 0
                i.up = filter!(e->e≠j,i.up)
                changed = true
            end
        end
    end

    # for i in c.result.lb
    #     occurenceI = 0
    #     indexI = []
    #     for j in D
    #         elementArray = filter( x -> x == i, j.up )
    #         occurenceI += length(elementArray) 
    #         if length(elementArray) == 1
    #             push!(indexI, j)
    #         end
    #     end
    #     if occurenceI == 1
    #         #addLb(D[indexI[1]] , [I])
    #         filter!(e->e≠i,D[indexI].up)
    #         D[indexI]
    #         changed = true
    #     end
    # end

    for i in c.result.lb
        indexI = []
        elementArray = filter( x -> x == i, dtest.lb )
        if length(elementArray) ==0
          occurenceI = 0
          for j in 1:length(D)
              elementArray = filter( x -> x == i, D[j].up )
              occurenceI += length(elementArray) 
              if length(elementArray) == 1
                  push!(indexI, j)
              end
          end
          if occurenceI == 1
              addLb(D[indexI[1]], [i])
              filter!(e->e≠i,D[indexI[1]].up)
              D[indexI]
              changed = true
          end
        end
        for i in D
            if i.minC < length(i.lb)
              i.minC = length(i.lb)
            end
      
            if i.maxC == length(i.lb)
              i.up = []
            end
          end
    end

    for i in dtest.up
        elementArray = filter( x -> x == i, c.result.up)
        nbI = length(elementArray)
        elementArray = filter( x -> x == i, c.result.lb)
        nbI += length(elementArray)
        if nbI == 0
            for j in D
                filter!(e->e≠i,j.up)
                changed = true
            end
        end
    end

    # for i in dtest.up
    #     elementArray = filter( x -> x == i, c.result.up)
    #     nbI = length(elementArray)
    #     elementArray = filter( x -> x == i, c.result.lb)
    #     nbI += length(elementArray)
    #     if nbI == 0
    #         for j in D
    #             filter!(e->e≠i,j.up)
    #             changed = true
    #         end
    #     end
    # end
    return changed
end

function filtrate_intersection(io, D :: Vector{Domain}, c :: Constraint)
    changed = false
    if(length(c.domains)==1)
        dtest = D[1]
    else
        dtest = intersect_domain(D[1],D[2])
    end 
   
    for i in D[3:length(D)]
        dtest = intersect_domain(dtest,D[i])
    end 

    for i in c.result.lb
        elementArray = filter( x -> x == i, dtest.lb)
        if length(elementArray) == 0
            for j in D
                elementArray = filter( x -> x == i, j.up)
                if length(elementArray) > 0
                    filter!(e->e≠i,j.up)
                    addLb(j, [i])
                    changed = true
                end
            end
        end
    end

    for i in c.result.up
        elementArray = filter( x -> x == i, dtest.up)
        nbI = length(elementArray)
        elementArray = filter( x -> x == i, dtest.lb)
        nbI += length(elementArray)
        if nbI == 0
            filter!(e->e≠i,c.result.up)
            changed = true
        end
    end
    return changed
end

function filtrate_subDomain(io, d :: Vector{Domain}, c :: Constraint)

    return true

end