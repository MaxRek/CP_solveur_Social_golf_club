function split(io, P :: CSP, pile :: Stack{CSP})
    println(io,"Je split")
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

function split_add_up_in_lb(d :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    dr.lb = copy(d.lb) ; dr.up = copy(d.up) ; dr.minC = d.minC ; dr.maxC = d.maxC
    println("before dr = ",dr)
    e_added = dr.up[Int64(round(rand()*(size(dr.up)[1]-1))+1)]
    println("e_added = ",e_added)
    del(dr,[e_added])
    addLb(dr, [e_added])
    println("after dr = ",dr)

    return dr
end