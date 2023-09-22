# function propagate(D,F) -> D
#   G <- null
#   while F != null
#       F <- F\{fi}                 #select a function, remove if from faire
#       G <- G U {fi}               #add it to F
#       D' <- fi(D)                 #filter domains with fi
#       F <- F U G' and G <- G/G'
#           where pour chq g dans G, il existe un xk appartenant à var(g), D'k != Dk -> g appartient à G'
#               #functions whose at least one variable has been modified must be woken

function propagation()
    println("Propagation a faire")
end