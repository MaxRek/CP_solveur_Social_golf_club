#solveur_CP par Coralie MARCHAU et Maxime REKAR

import Dates

using Dates
using DataStructures

include("src/domain.jl")
include("src/constraint.jl")
include("src/solve.jl")

include("in/G_test.jl")
include("in/S_test.jl")
include("src/operation.jl")
include("src/writer/writer.jl")
include("src/parser/parser.jl")


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
        ,Vector{Constraint}()
    )
    push!(S.C,Constraint(S.D,"union",Domain(collect(1:5),Vector{Int64}(),5,5)))
    push!(S.C,Constraint(S.D,"intersect",Domain(Vector{Int64}(),collect(1:5),5,5)))


    solve(io, S)

    close(io)

end

function parse_CSP(pathtoholder)
    CSPs = Vector{CSP}()
    fnames = getfname(pathtoholder)
    a = []
    for f in fnames
        push!(CSPs,loadCP(String(pathtoholder*"/"*f)))
    end
    return CSPs
end

CP()