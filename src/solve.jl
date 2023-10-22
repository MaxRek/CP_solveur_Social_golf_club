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

using DataStructures

function solve(io,P :: CSP)
    print(io,"je solve")
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
            split(io, Pp, pile)
        end
        gardefou += 1
    end

end

function feasible_CSP(io, P :: CSP)
    return true
end

