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

function solve(io,P,X,D,C)
    print(io,"je solve")
end

function solve_v(io,P,X,D,C)
    print(io,"je solve, mais verbeusement")
end

