mutable struct Constraint
    domains :: Vector{Int64}
    operande :: String
    result :: Domain
end

function print_constraint(io, v, C :: Vector{Constraint})
    if(v == 0)
        i = 1
        while(i<=size(C)[1])
            println("C",i,", Concerned domain = ",C[i].domains,", operande = \"",C[i].operande,"\" result = ")
            print_domain(io,v,C[i].result)
            i += 1
        end
    else
        if(v == 1)
            i = 1
            while(i<=size(C)[1])
                println(io,"C",i,", Concerned domain = ",C[i].domains,", operande = \"",C[i].operande,"\" result = ")
                print_domain(io,v,[C[i].result])
                i += 1
            end
        end
    end
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
    if(length(c.domains)==1)
        dtest = D[1]
    else
        dtest = intersect_domain(D[1],D[2])
    end 

    for i in D[3:length(D)]
        dtest = intersect_domain(dtest,i)
    end 
    return isReachable(c.result, dtest)   
end

function feasibility_subDomain(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    return subDomain(io,1,D[2],D[1])
end