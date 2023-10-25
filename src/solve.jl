mutable struct CSP
    X :: Vector{Int64}
    D :: Vector{Domain}
    C :: Vector{Constraint}
end

#function solve(P = (X,D,C):CSP)-> Map<W,D>
#S : Set(CSP)
#P':CSP
#   S <- {P}                                            #   
#   while S != null                                     #   
#      P'<- select(S)                                   #   select a CSP
#      S<- S\{P'}                                       #   remove it from S
#      P'<-propagate(P')                                #   reduce seach space of P'
#      if happy                                         #   expected solution found
#           then return slution(P")                     #
#           elif unsat(P')                              #   there may still be solutions in P'
#               then S<-S U split_search_space(P')      #
#                            # split into "smaller" CPSs, and add them to S
#   endwhile
#   return null

function solve(io,P :: CSP)
    println(io,"je solve")
    pile = Stack{CSP}()
    push!(pile, P)
    gardefou = 1
    stop = false

    while(!isempty(pile) && gardefou <= 2000 && !stop)
        Pp = pop!(pile)
        println(io, "_____________\nNouvelle itération \n gardefou = ", gardefou, "nb d'élements dans la pile = ",length(pile))
        
        println(io,"\n--------CSP--------")
        print_CSP(io, 1, Pp)
        println(io,"----------------\n")
        
        propagation(io, Pp)
        if(is_ended_CSP(io,Pp))
            println(io, "---Pp is ended, checking for feasible on---")
            if(feasible_CSP(io,Pp))
                stop = true
                println(io, "---Pp is valid, end of solving---\n")
            else
                println(io, "---Pp isn't valid, moving on---\n")
            end
        else
            println(io, "---Pp isn't valid, moving on---\n")
            split_domain(io, Pp, pile)
        end
        gardefou += 1
    end

    if(isempty(pile))
        println(io,"--------------------------------\nLa pile est vide\nFin de résolution\n--------------------------")
    end

end

function feasible_CSP(io, P :: CSP)
    isItFeasible = true
    for i in 1:length(P.C)
        isItFeasible = isItFeasible && check_feasibility(io, i, P.D[P.C[i].domains], P.C[i])
    end
        
    return isItFeasible
end

function is_ended_CSP(io, Pp :: CSP)
    isItOver = feasible_CSP(io, Pp :: CSP)
    for i in Pp.D
        isItOver = isItOver && i.up == [] #un domaine stable n'a plus d'éléments possibles à l'ajout, si fini tt domaine est stable
    end
    return isItOver
end

function print_CSP(io, v, P :: CSP)
    if(v == 0)
        println("CSP :")
        println("   -Domains :")
        print_domain(io, v, P.D)
        println("   -Constraint :")
        print_constraint(io, v,P.C)
    else
        if(v == 1)
            println(io,"CSP :")
            println(io,"   -Domains :")
            print_domain(io, v, P.D)
            println(io,"   -Constraint :")
            print_constraint(io, v, P.C)
        end
    end
end