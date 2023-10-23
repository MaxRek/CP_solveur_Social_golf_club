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
    println(io,"\n  before dr = ",dr)
    e_added = dr.up[Int64(round(rand()*(size(dr.up)[1]-1))+1)]
    println(io,"  e_added = ",e_added)
    del(io,dr,[e_added])
    println(io,"  after del, dr = ",dr)

    addLb(dr, [e_added])
    println(io,"  after add dr = ",dr,"\n")
    if(dr.minC == dr.maxC)
        println(io,"    d.minC == d.maxC, d.lb = ",d.lb)
        if(size(dr.lb)[1]== dr.minC)
            println(io,"    size(d.lb) == dr.minC, dr = ", dr,", dr.up = ",dr.up)
            del(io,dr, dr.up)
        end
    else
        if(dr.minC > dr.maxC)
            println(io, "ERREUR : minC > maxC, dr = ", dr)
        end
    end

    return dr
end