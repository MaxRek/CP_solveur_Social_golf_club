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
end
    
function feasibility_union(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    return true
end

function feasibility_intersect(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    return true
end

function feasibility_subDomain(io, v :: Int64, D :: Vector{Domain}, c :: Constraint)
    return true
end