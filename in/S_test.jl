function split_domain(io, P :: CSP, pile :: Stack{CSP})
    #println(io,"Je split")
    i = 1
    d_not_finished = Vector{Int64}()
    for d in P.D
        if(d.minC == size(d.lb)[1] || d.maxC == size(d.lb)[1])
            append!(d_not_finished, i) 
        end
        i += 1
    end
    println(io, "Domains non terminé : ",d_not_finished)
    if(size(d_not_finished)[1] > 1)
        d_modify1 = 0 ; d_modify2 = 0
        while(d_modify1 == d_modify2)
            d_modify1 = d_not_finished[Int(round(rand()*((size(d_not_finished)[1]-1)))) + 1]
            d_modify2 = d_not_finished[Int(round(rand()*((size(d_not_finished)[1]-1)))) + 1]
        end
        println(io, "d_modify1 = ", d_modify1,", d_modify2 = ",d_modify2)
        P1 = deepcopy(P) ; P2 = deepcopy(P)

        # println(io,"Avant split Domaines de P1, puis P2 :")
        # println(io,"----------------------------")
        # print_domain(io,1,P1.D)
        # println(io,"----------------------------")
        # print_domain(io,1,P2.D)

        P1.D[d_modify1] =split_add_up_in_lb(io, P1.D[d_modify1])
        P2.D[d_modify2] =split_add_up_in_lb(io, P2.D[d_modify2])

        # println(io,"Apres split Domaines de P1, puis P2 :")
        # println(io,"----------------------------")
        # print_domain(io,1,P1.D)
        # println(io,"----------------------------")
        # print_domain(io,1,P2.D)

        push!(pile, P1)
        push!(pile, P2)
    else
        if(size(d_not_finished)[1] == 1)
            d_modify1 = d_not_finished[Int(round(rand()*((size(d_not_finished)[1]-1)))) + 1]
            P1 = deepcopy(P)
            P1.D[d_modify1] = split_add_up_in_lb(io, P1.D[d_modify1])
            # println(io,"Domaines de P1 :")
            # print_domain(io,1,P1.D)
            
            # push!(pile,P1)
        else
            println(io,"ERREUR : CSP terminé mais pas détécté\n ---------------------------")
            print_CSP(io,1,P)
            println(io,"----------------------------")
        end
    end
end

function split_add_up_in_lb(io, d :: Domain)
    dr = Domain(Vector{Int64}(),Vector{Int64}(),0,0)
    dr.lb = copy(d.lb) ; dr.up = copy(d.up) ; dr.minC = d.minC ; dr.maxC = d.maxC
    # println(io,"\n  before dr = ")
    # print_domain(io, 1, [d])
    e_added = dr.up[Int(round(rand()*((size(dr.up)[1])-1))) + 1]
    #println(io,"  e_added = ",e_added)
    del(dr,[e_added])
    #println(io,"  after del, dr = ",dr)

    addLb(dr, [e_added])
    #println(io,"  after add dr = ",dr,"\n")
    if(dr.minC == dr.maxC)
        #println(io,"    d.minC == d.maxC, d.lb = ",d.lb)
        if(size(dr.lb)[1]== dr.minC)
            #println(io,"    size(d.lb) == dr.minC, dr = ", dr,", dr.up = ",dr.up)
            del(dr, dr.up)
        end
    else
        if(dr.minC > dr.maxC)
            #println(io, "ERREUR : minC > maxC, dr = ", dr)
        else
            dr.minC += 1
        end
    end

    if(dr.minC == dr.maxC && dr.minC == size(dr.lb)[1]==dr.minC)
        e = copy(dr.up)
        del(dr, e)
    end

    return dr
end