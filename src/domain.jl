mutable struct Domain
    lb :: Vector{Int64}
    up :: Vector{Int64}
    minC :: Int64
    maxC :: Int64
end
    
function addLb(d :: Domain, v :: Vector{Int64})
    for j in v
        trouve = false
        if(d.lb!=[])
            if(j>d.lb[1])
                stop = false
                i = 1
                while(i < size(d.lb)[1] && !stop && !trouve)
                    if(d.lb[i+1]<j)
                        i+=1
                    else
                        if(d.lb[i] == j)
                            stop = true
                            trouve == true
                        else
                            stop = true  
                        end
                    end
                end
                if(!stop)
                    append!(d.lb,j)
                else
                    if(!trouve)
                        insert!(d.lb,i+1,j)
                    end
                end
            else
                insert!(d.lb,1,j)
            end
        else
            append!(d.lb,j)
        end
    end
end

function addUp(d :: Domain, v :: Vector{Int64})
    for j in v
        if(!(j in d.lb))
            if(d.up!=[])
                trouve = false
                if(j>d.up[1])
                    stop = false
                    i = 1
                    while(i < size(d.up)[1] && !stop )
                        if(d.up[i+1]<j)
                            i+=1
                        else
                            if(d.up[i+1] == j)
                                stop = true
                                trouve = true
                            else
                                stop = true
                            end
                        end
                    end
                    if(!trouve)
                        if(!stop )
                            append!(d.up,j)
                        else
                            insert!(d.up,i+1,j)
                        end
                    end
                else
                    insert!(d.up,1,j)
                end
            else
                append!(d.up,j)
            end
        end
    end
end

function del(d :: Domain, v :: Vector{Int64})
    #println("\n  Into del, d = ",d,", v = ",v)
    vp = copy(v)

    for j in vp
        #println("     Loop for j, or not , j = ",j,", d = ",d)
        if(j in d.lb)
            #println("        j in d.lb, j = ",j,", d.lb = ",d.lb)
            if(j!=d.lb[1])
                stop = false
                trouve = false
                i = 1
                while(i <= size(d.lb)[1] && !stop )
                    if(d.lb[i]>j)
                        i+=1
                    else
                        if(d.lb[i] == j)
                            stop = true
                            trouve == true
                        else
                            stop = true  
                        end#println("          j was found in d.lb")
                    end
                end
                if(trouve)
                    popat!(d.lb,i)
                end
            else
                popat!(d.lb,1)
            end
        end
        if(size(d.up)[1]>0)
            if(j in d.up)
                #println("        j in d.up, j = ",j,", d.up = ",d.up)
                if(j!=d.up[1])
                    stop = false
                    trouve = false
                    i = 2
                    while(i <= size(d.up)[1] && !stop )
                        if(d.up[i]>j)
                            i+=1
                        else
                            if(d.lb[i] == j)
                                stop = true
                                trouve == true
                            else
                                stop = true  
                            end#println("          j was found in d.lb")
                        end
                    end
                    if(trouve)
                        popat!(d.up,i)
                    end
                else
                    popat!(d.up,1)
                end
            end
        else
            #println("\n        j isn't in d.lb or d.up, j = ",j,", d.lb = ",d.lb,", d.up = ",d.up)
        end
        #println("     END Loop")
    end
    #println("  After del, vp = ",vp,", d = ",d)
end


function print_domain(io, v, D :: Vector{Domain})
    if(v == 0)
        i = 1
        while(i<=size(D)[1])
            println("X",i,", lb = ",D[i].lb,", up = ",D[i].up,", minC = ",D[i].minC,", maxC = ",D[i].maxC)
            i += 1
        end
    else
        if(v == 1)
            i = 1
            while(i<=size(D)[1])
                println(io,"X",i,", lb = ",D[i].lb,", up = ",D[i].up,", minC = ",D[i].minC,", maxC = ",D[i].maxC)
                i += 1
            end
        end
    end
end