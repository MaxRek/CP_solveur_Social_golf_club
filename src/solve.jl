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

    while(!isempty(pile) && gardefou <= 20 && !stop)
        Pp = pop!(pile)
        println(io, "_____________\nNouvelle itération \n Pp = ",Pp,"\n gardefou = ", gardefou)
        propagation(io, Pp)
        if(is_ended_CSP(io,Pp))
            println(io, "Pp is ended, checking for feasible on")
            if(feasible_CSP(io,Pp))
                stop = true
            else
                println(io, "Pp isn't valid, moving on")
            end
        else
            println(io, "Pp isn't ended, spliting Pp")
            P1, P2 = split(io, Pp, pile)
            push!(pile, P1)
            push!(pile, P2)
        end
        gardefou += 1
    end

end

function feasible_CSP(io, P :: CSP)
    return true
end

function is_ended_CSP(io, Pp :: CSP)
    bool = false ; stop = false
    i = 1
    while(i <= size(Pp.D)[1] && !stop)
        d = Pp.D[i]
        if(size(d.lb)[1] < d.minC || d.minC < d.maxC)
            stop = true
        end
        i += 1
    end
    if(!stop)
        bool = true
    end

    return bool
end

function print_CSP(io, v, P :: CSP)
    if(v == 0)
        println("CSP :")
        println("   -Domains :")
        print_domain(io, v, P.D)
        println("   -Constraint :")
        print_constraint(io, v, P.C)
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

function print_domain(io, v, D :: Vector{Domain})
    if(v == 0)
        i = 1
        while(i<=size(D)[1])
            println("X",i,", lb = ",D[i].lb,", up = ",D[i].up,", minC = ",D[i].minC,", maxC = ",D[i].maxC)
            i += 1
        end
    else
        if(v == 1)
            i = 1
            while(i<=size(D)[1])
                println(io,"X",i,", lb = ",D[i].lb,", up = ",D[i].up,", minC = ",D[i].minC,", maxC = ",D[i].maxC)
                i += 1
            end
        end
    end
end

function print_constraint(io, v, C :: Vector{Constraint})
    if(v == 0)
        i = 1
        while(i<=size(C)[1])
            println("C",i,", Concerned domain = ",C[i].domains,", operande = \"",C[i].operande,"\" result = "),print_domain(io,v,[C[i].result])
            i += 1
        end
    else
        if(v == 1)
            i = 1
            while(i<=size(C)[1])
                println(io,"C",i,", Concerned domain = ",C[i].domains,", operande = \"",C[i].operande,"\" result = "),print_domain(io,v,[C[i].result])
                i += 1
            end
        end
    end
end