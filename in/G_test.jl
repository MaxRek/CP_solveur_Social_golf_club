# function propagate(D,F) -> D
#   G <- null
#   while F != null
#       F <- F\{fi}                 #select a function, remove if from faire
#       G <- G U {fi}               #add it to F
#       D' <- fi(D)                 #filter domains with fi
#       F <- F U G' and G <- G/G'
#           where pour chq g dans G, il existe un xk appartenant à var(g), D'k != Dk -> g appartient à G'
#               #functions whose at least one variable has been modified must be woken

function propagation(io, P :: CSP)
    println(io,"__________\n Propagation \n__________")
    changed = true
    while changed
        changed = false
        for c in P.C
        changed = changed || filtrate(io, P.D[c.domains],c)
        end
    end
end

function filtrate(io, D :: Vector{Domain}, c :: Constraint)
    if(c.operande == "union")
      filtrate_union(io, D, c)
    else
      if (c.operande == "intersect")
        filtrate_intersect(io, D, c)
      else
          if (c.operande == "subdomain")
            filtrate_subDomain(io, D, c)
          end
      end
    end
end

function filtrate_union(io, D :: Vector{Domain}, c :: Constraint)
    dtest = union_domain(D[1],D[2])
    for i in D[3:length(D)]
        dtest = union_domain(dtest,D[i])
    end 

    for i in D
        for j in i.up
            elementArray = filter( x -> x == j, c.result.up )
            if length(elementArray) == 0
                i.up = filter!(e->e≠j,i.up)
            end
        end
    end

    for i in c.result.lb
        occurenceI = 0
        indexI = []
        for j in D
            elementArray = filter( x -> x == i, j.lb )
            occurenceI += length(elementArray) 
            if length(elementArray) == 1
                push!(indexI, j)
            end
        end
        if occurenceI == 1
            addLb(D[indexI], [i])
            filter!(e->e≠i,D[indexI].up)
            D[indexI]
        end
    end

for i in dtest
    elementArray = filter( x -> x == i.up, c.result.up)
    nbI = length(elementArray)
    elementArray = filter( x -> x == i.lb, c.result.lb)
    nbI += length(elementArray)
        if nbI == 0
            for j in D
                filter!(e->e≠i,j.up)
            end
        end
    end
end

function filtrate_intersection(io, D :: Vector{Domain}, c :: Constraint)
    dtest = intersection_domain(D[1],D[2])
    for i in D[3:length(D)]
        dtest = intersection_domain(dtest,D[i])
    end 

    for i in c.result.lb
        elementArray = filter( x -> x == i, dtest.lb)
        if length(elementArray) == 0
            for j in D
                elementArray = filter( x -> x == i, j.up)
                if length(elementArray) > 0
                    filter!(e->e≠i,j.up)
                    addLb(j, [i])
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
        end
    end
end

function filtrate_subDomain(io, d :: Vector{Domain}, c :: Constraint)


end