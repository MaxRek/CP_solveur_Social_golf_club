#solveur_CP par Coralie MARCHAU et Maxime REKAR

import Dates

using Dates

include("src/loader.jl")
include("in/G_test.jl")
include("in/S.jl")
include("src/dataStructure.jl")
include("src/solve.jl")

function CP()

    nameLog = Dates.format(now(),"ddmm-HHMM")

    io = open(String("out/log_"*nameLog*".txt"), "w")
    println("Hello world")
    println("Solveur_CP")
    println("Verbosité ? (O pour Oui)")
    
    i = readline()
    if (i == "O" || i == "o")
        propagation_v(io)
        solve_v(io,1,2,3,4)   
    else
        propagation(io)
        solve(io,1,2,3,4)
    end
    
    

    close(io)

end

CP()