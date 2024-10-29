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
    
    #Input : 
    #écriture de logs ? Attention, les logs peuvent être lourds
    printlog = 0

    #Nb d'itérations maximum dans le solveur
    limite = 2000

    #s,g,w
    s = 4 ; g = 4 ; w = 4

    #noms des logs
    name = Dates.format(now(),"ddmm-HHMM")
    result = open(String("out/result_"*name*".txt"), "w")
    if(printlog == 1)
        log = open(String("out/log_"*name*".txt"), "w")
    else
        log = 0
    end

    path = ("in/modeles/")

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

    fnames, CSPs = parse_CSP(path)
    time = zeros(1,length(fnames))
    status = Array{String}(undef,length(fnames))
    
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