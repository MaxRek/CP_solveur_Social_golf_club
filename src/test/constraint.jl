import Dates

using Dates

include("../domain.jl")
include("../constraint.jl")
include("../operation.jl")
include("../solve.jl")

nameLog = Dates.format(now(),"ddmm-HHMM")
io = open(String("out/log_test_"*nameLog*".txt"), "w")

S_u1 = CSP(
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
        Constraint([1,2,3,4,5],"union", Domain([1,2,3,4,5],[],5,5))
    ])
)

S_u2 = CSP(
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
        Constraint([1,2,3,4,5],"union", Domain([1,2,3,4,5],[],5,5))
    ])
)

S_u3 = CSP(
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
        Constraint([1,2,3,4,5],"union", Domain([1,2,3,4,5],[],5,5))
    ])
)

S_u4 = CSP(
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
        Constraint([1,2,3,4,5],"union", Domain([1,2,3,4,5],[],5,5))
    ])
)


    

println(io, "----------------------------------------------\nTests unitaires de constraint.jl\n----------------------------------------------")

println(io,"\n ------- Test feasibility : -------\n")
println(io,"---Constraint : intersect : ---\n")

S_i1 = CSP(
        Vector{Int64}([1,2,3,4,5]),
        Vector{Domain}([
            Domain(Vector{Int64}([1]),Vector{Int64}(),1,1),
            Domain(Vector{Int64}([2]),Vector{Int64}(),1,1),
            Domain(Vector{Int64}([3]),Vector{Int64}(),1,1),
            Domain(Vector{Int64}([4]),Vector{Int64}(),1,1),
            Domain(Vector{Int64}([5]),Vector{Int64}(),1,1)
        ])
        ,
        Vector{Constraint}([
            Constraint([1,2,3,4,5],"intersect", Domain([],[1,2,3,4,5],0,0)),
        ])
    )

if(check_feasibility(io, 1, S_i1.D[S_i1.C[1].domains],S_i1.C[1]))
    println(io,"Prévu : S_i1 valide\n")
else
    println(io,"ERREUR : S_i1 est considéré invalide\n----------------------------------")
    print_CSP(io, 1, S_i1)
    println(io,"----------------------------------\n")
end

S_i2 = CSP(
    Vector{Int64}([1,2,3,4,5]),
    Vector{Domain}([
        Domain(Vector{Int64}([1]),Vector{Int64}([]),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([2,3,4,5]),1,1),
        Domain(Vector{Int64}([1]),Vector{Int64}(),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([2,3,4,5]),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([2,3,4,5]),1,1)
    ])
    ,
    Vector{Constraint}([
        Constraint([1,2,3,4,5],"intersect", Domain([],[1,2,3,4,5],0,0)),
    ])
)

if(!check_feasibility(io, 1, S_i2.D[S_i2.C[1].domains],S_i2.C[1]))
    println(io,"Prévu : S_i2 n'est pas valide\n")
else
    println(io,"ERREUR : S_i2 est considéré valide\n----------------------------------")
    print_CSP(io, 1, S_i2)
    println(io,"----------------------------------\n")
end

S_i3 = CSP(
    Vector{Int64}([1,2,3,4,5]),
    Vector{Domain}([
        Domain(Vector{Int64}([1]),Vector{Int64}([]),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([3,4,5]),1,1),
        Domain(Vector{Int64}([2]),Vector{Int64}(),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([3,4,5]),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([3,4,5]),1,1)
    ])
    ,
    Vector{Constraint}([
        Constraint([1,2,3,4,5],"intersect", Domain([],[1,2,3,4,5],0,0)),
    ])
)

if(check_feasibility(io, 1, S_i3.D[S_i3.C[1].domains], S_i3.C[1]))
    println(io,"Prévu : S_i3 est valide\n")
else
    println(io,"ERREUR : S_i3 est considéré invalide\n----------------------------------")
    print_CSP(io, 1, S_i3)
    println(io,"----------------------------------\n")
end

S_i4 = CSP(
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
        Constraint([1,2,3,4,5],"intersect", Domain([],[1,2,3,4,5],0,0)),
    ])
)

if(check_feasibility(io, 1, S_i4.D[S_i4.C[1].domains],  S_i4.C[1]))
    println(io,"Prévu : S_i4 est valide\n")
else
    println(io,"ERREUR : S_i4 est considéré invalide\n----------------------------------")
    print_CSP(io, 1, S_i4)
    println(io,"----------------------------------\n")

end

S_i5 = CSP(
    Vector{Int64}([1,2,3,4,5]),
    Vector{Domain}([
        Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),2,2),
        Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1),
        Domain(Vector{Int64}(),Vector{Int64}([1,2,3,4,5]),1,1)
    ])
    ,
    Vector{Constraint}([
        Constraint([1,2,3,4,5],"intersect", Domain([],[1,2,3,4,5],0,0)),
    ])
)

if(!check_feasibility(io, 1, S_i5.D[S_i5.C[1].domains], S_i5.C[1]))
    println(io,"Prévu : S_i5 est invalide\n")
else
    println(io,"ERREUR : S_i5 est considéré invalide\n----------------------------------")
    print_CSP(io, 1, S_i5)
    println(io,"----------------------------------\n")

end

println(io, "----------------------------------------------\nFin Tests unitaires de constraint.jl\n----------------------------------------------")
