mutable struct Constraint
    domains :: Vector{Domain}
    operande :: String
    result :: Domain
end

function print_constraint(io, v, C :: Vector{Constraint})
    if(v == 0)
        i = 1
        while(i<=size(C)[1])
            println("C",i,", Concerned domain = ")
            print_domain(io,0,C[i].domains)
            println(", operande = \"",C[i].operande,"\" result = ")
            print_domain(io,v,[C[i].result])
            i += 1
        end
    else
        if(v == 1)
            i = 1
            while(i<=size(C)[1])
                println(io,"C",i,", Concerned domain = ")
                print_domain(io,v,C[i].domains)
                println(io,", operande = \"",C[i].operande,"\" result = ")
                print_domain(io,v,[C[i].result])
                i += 1
            end
        end
    end
end

function filtrate(io, c :: Constraint)
    if(c.operande == "union")
      filtrate_union(io, c)
    else
      if (c.operande == "intersect")
        filtrate_intersect(io, c)
      else
          if (c.operande == "subdomain")
            filtrate_subDomain(io, c)
          end
      end
    end
end

function filtrate_union(io, c :: Constraint)
    dtest = union_domain(D[1],D[2])
    for i in D[3:length(D)]
    dtest = union_domain(dtest,D[i])
    end 

    for i in c.domains
        for j in i.up
            elementArray = filter( x -> x == j, c.result.up )
            if length(elementArray) == 0
            i.ub = filter!(e->e≠j,i.up)
            end
        end
    end

    for i in dtest.lb
        occurenceI = 0
        indexI = []
        for j in c.domains
            elementArray = filter( x -> x == i, c.result.lb )
            occurenceI += length(elementArray) 
            if length(elementArray) > 0
                push!(indexI, j)
            end
        end
        if occurenceI == 1
            addLb(c.domains[indexI], [i])
            filter!(e->e≠i,c.domains[indexI].up)
            c.domains[indexI]
        end
    end

for i in dtest
    elementArray = filter( x -> x == i, c.result.up)
    nbI = length(elementArray)
    elementArray = filter( x -> x == i, c.result.lb)
    nbI += length(elementArray)
        if nbI == 0
            for j in c.domains
                filter!(e->e≠i,j.up)
            end
        end
    end
end

function filtrate_intersection(io, c :: Constraint)
    dtest = intersection_domain(D[1],D[2])
    for i in D[3:length(D)]
        dtest = intersection_domain(dtest,D[i])
    end 

    for i in c.result.lb
        elementArray = filter( x -> x == i, dtest.lb)
        if length(elementArray) == 0
            for j in c.domains
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

function filtrate_subDomain(io, c :: Constraint)


end

function check_feasibility(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    bool = false
    if(c.operande == "union")
        bool = feasibility_union(io, v, D, c)
    else
        if (c.operande == "intersect")
            bool = feasibility_intersect(io, v, D, c)
        else
            if (c.operande == "subdomain")
                bool = feasibility_subDomain(io, v, D, c)
            end
        end
    end
    return bool
end

function isReachable(objectiveDomain, currentDomain)
    isPresent = false
    allPresent = true
    for i in objectiveDomain.lb
      for j in currentDomain.lb
        isPresent = isPresent || i==j
      end
      
      for j in currentDomain.up
        isPresent = isPresent || i==j
      end
      allPresent = allPresent && isPresent
    end
    
    allPresent = allPresent && (currentDomain.minC <= currentDomain.maxC)
    allPresent = allPresent && (currentDomain.minC <= objectiveDomain.minC)
    allPresent = allPresent && (objectiveDomain.maxC <= currentDomain.maxC)
    
    return allPresent
end
      
function feasibility_union(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    dtest = union_domain(D[1],D[2])
        for i in D[3:length(D)]
            dtest = union_domain(dtest,i)
        end 
    return isReachable(c.result, dtest) 
end
  
function feasibility_intersect(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    dtest = intersect_domain(D[1],D[2])
    for i in D[3:length(D)]
        dtest = intersect_domain(dtest,i)
    end 
    return isReachable(c.result, dtest)   
end

function feasibility_subDomain(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    return subDomain(io,1,D[2],D[1])
end