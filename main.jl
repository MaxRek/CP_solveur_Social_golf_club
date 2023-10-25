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

function parse_CSP(pathtoholder)
    CSPs = Vector{CSP}()
    fnames = getfname(pathtoholder)
    a = []
    for f in fnames
        push!(CSPs,loadCP(String(pathtoholder*"/"*f)))
    end
    return fnames, CSPs
end

function main()
    #Log & modeles
    if(!isdir("out"))
        mkdir("out")
    end
    if(!isdir("in/modeles"))
        mkdir("in/modeles")
        generateModelsTests(4,4,4)
    end
    if(length(readdir("in/modeles")) == 0)
        generateModelsTests(4,4,4)
    end

    nameLog = Dates.format(now(),"ddmm-HHMM")
    log = open(String("out/log_"*nameLog*".txt"), "w")
    result = open(String("out/result_"*nameLog*".txt"), "w")
    path = ("in/modeles/")

    fnames, CSPs = parse_CSP(path)
    
    time = zeros(1,length(fnames))
    
    solve(log,CSPs[10])

    # for i in 1:length(fnames)
    #     time[i] = @elapsed solve(log,CSPs[i])
    # end

    println(result,time)

    close(result)
    close(log)
end
main()