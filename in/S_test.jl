function split(io, P :: CSP, pile :: Stack{CSP})
    println(io,"Je split")
    P1 = co
    i = 1
    d_not_finished = Int64[]()
    for d in P.D
        if(d.minC != size(d.lb)[1] && d.maxC != size(d.lb)[1])
            append!(d_not_finished, i) 
        end
        i += 1
    end

    d_modify = round(rand()*(size(a)[1]-1))


end

function split_add_up_in_lb(io, d :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    dr.lb = copy(d.lb) ; dr.up = copy(d.up) ; dr.minC = d.minC ; dr.maxC = d.maxC
    println(io,"before dr = ",dr)
    e_added = dr.up[Int64(round(rand()*(size(dr.up)[1]-1))+1)]
    println(io,"e_added = ",e_added)
    del(dr,[e_added])
    println(io,"after del, dr = ",dr)

    addLb(dr, [e_added])
    println(io,"after add dr = ",dr)
    if(d.minC == d.maxC)
        if(size(d.lb)[1]== d.minC)
            print("d = ", d,"d.up = ",d.up)
            for k in d.up
                println("k = ",k)
                del(d, [k])
            end
        end
    else
        println(io, "ERREUR : minC > maxC, d = ", d)
    end

    return dr
end