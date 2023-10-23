import Dates

using Dates

include("../dataStructure.jl")

nameLog = Dates.format(now(),"ddmm-HHMM")
io = open(String("out/log_test_"*nameLog*".txt"), "w")

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
            Constraint([1,2],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([1,3],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([1,4],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([1,5],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([2,3],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([2,4],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([2,5],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([3,4],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([3,5],"intersect", Domain([],[1,2,3,4,5],1,1)),
            Constraint([4,5],"intersect", Domain([],[1,2,3,4,5],1,1))
        ])
    )

println(io,"----------------------------------------------\nTESTS UNITAIRES de src/solve.jl & in/S_test\n----------------------------------------------")

println(io,"-----------------------------------\n S = ")
print_CSP(io, 1, S)
println(io,"-----------------------------------")


println(io,"\nPremier Test, split_add_up_in_lb\n")

s1 = deepcopy(S)
println(io,"ajout de bornes sup a inf pour domaine 1")
s1.D[1] = split_add_up_in_lb(io, s1.D[1])
println(io,"D[1] =",s1.D[1])

println(io, "s1 is ended ? = ",is_ended_CSP(io, s1))

println(io,"ajout de bornes sup a inf pour domaine 2")
s1.D[2] = split_add_up_in_lb(io, s1.D[2])
println(io,"D[2] =",s1.D[2])

println(io, "s1 is ended ? = ",is_ended_CSP(io, s1))

println(io,"ajout de bornes sup a inf pour domaine 3")
s1.D[3] = split_add_up_in_lb(io, s1.D[3])
println(io,"D[3] =",s1.D[3])

println(io, "s1 is ended ? = ",is_ended_CSP(io, s1))

println(io,"ajout de bornes sup a inf pour domaine 4")
s1.D[4] = split_add_up_in_lb(io, s1.D[4])
println(io,"D[4] =",s1.D[4])

println(io, "s1 is ended ? = ",is_ended_CSP(io, s1))

println(io,"ajout de bornes sup a inf pour domaine 5")
s1.D[4] = split_add_up_in_lb(io, s1.D[5])
println(io,"D[5]",s1.D[5])

println(io, "s1 is ended ? = ",is_ended_CSP(io, s1))

println(io, "Fin des tests de solve.jl")

close(io)