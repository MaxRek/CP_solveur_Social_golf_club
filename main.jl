#solveur_CP par Coralie MARCHAU et Maxime REKAR

include("src/loader.jl")
include("in/G_test.jl")
include("in/S.jl")
include("src/dataStructure.jl")
include("src/solve.jl")

function CP()
    println("Hello world")
    println("Solveur_CP")
    propagation()
    solve(1,2,3,4)
end

CP()