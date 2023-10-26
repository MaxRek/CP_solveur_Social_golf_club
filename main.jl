#solveur_CP par Coralie MARCHAU et Maxime REKAR

import Dates

using Dates
using DataStructures
using MiniZinc

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

    name = Dates.format(now(),"ddmm-HHMM")
    printlog = 0
    
    if(printlog == 1)
        log = open(String("out/log_"*name*".txt"), "w")
    else
        log = 0
    end
    
    result = open(String("out/result_"*name*".txt"), "w")
    path = ("in/modeles/")

    fnames, CSPs = parse_CSP(path)
    
    time = zeros(1,length(fnames))
    status = Array{String}(undef,length(fnames))
    # i = 20
    # println(fnames[i])
    # solve(log,CSPs[i])

    # i = 11
    # println(fnames[i])
    # solve(log,CSPs[i])

    # i = length(fnames)
    # println(fnames[i])
    # solve(log,CSPs[i])
    

    for i in 1:length(fnames)
        time[i] = @elapsed r = solve(log, printlog,CSPs[i])
        if(typeof(r) == Int64)
            if(r == 0)
                status[i] = "Time out"
            else
                status[i] = "Pile empty"
            end
        else
            status[i] = "Sucess"
            print_domain(result, 1, r)
            println(result,"")
        end
    end

    println(result,fnames)
    println(result,status)
    println(result,time)
    close(result)
    
    if(printlog == 1)
        close(log)
    end
end
main()