#solveur_CP par Coralie MARCHAU et Maxime REKAR

import Dates

using Dates
using DataStructures


include("in/G_test.jl")
include("in/S_test.jl")
include("src/dataStructure.jl")
include("src/solve.jl")
include("src/operation.jl")

S = CSP(
        Vector{Int64}([1,2,3,4,5]),
        Vector{Domain}([
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1)
        ])
        ,
        Vector{Constraint}([
            Constraint(1,2,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(1,3,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(1,4,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(1,5,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(2,3,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(2,4,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(2,5,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(3,4,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(3,5,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(4,5,"intersect", Domain([],[1,2,3,4,5],1,1))
        ])
    )

function CP()

    nameLog = Dates.format(now(),"ddmm-HHMM")

    io = open(String("out/log_"*nameLog*".txt"), "w")
    
    S = CSP(
        Vector{Int64}([1,2,3,4,5]),
        Vector{Domain}([
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
            Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1)
        ])
        ,
        Vector{Constraint}([
            Constraint(1,2,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(1,3,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(1,4,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(1,5,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(2,3,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(2,4,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(2,5,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(3,4,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(3,5,"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint(4,5,"intersect", Domain([],[1,2,3,4,5],1,1))
        ])
    )

    solve(io, S)

    close(io)

end

nameLog = Dates.format(now(),"ddmm-HHMM")
io = open(String("out/log_rapide_"*nameLog*".txt"), "w")

s1 = deepcopy(S)
s1.D[1] = split_add_up_in_lb(io, s1.D[1])
s1.D[1] = split_add_up_in_lb(io, s1.D[1])
s1.D[1] = split_add_up_in_lb(io, s1.D[1])
s1.D[1] = split_add_up_in_lb(io, s1.D[1])
s1.D[1] = split_add_up_in_lb(io, s1.D[1])

close(io)
