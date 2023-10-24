import Dates

using Dates

include("../dataStructure.jl")

nameLog = Dates.format(now(),"ddmm-HHMM")
io = open(String("out/log_test_"*nameLog*".txt"), "w")

d1 = Domain([1], [2, 3], 1, 3)
d2 = Domain([1], [2, 3], 1, 3)
d3 = Domain([1], [2, 3], 2, 3)
d4 = Domain([1], [2, 4], 1, 3)
d5 = Domain([1,2], [2, 3], 2, 3)

if(
    compare_domain(d1,d2) && !compare_domain(d1,d3) && !compare_domain(d1,d4) && !compare_domain(d1,d5) &&
     !compare_domain(d2,d3) && !compare_domain(d2,d4) && !compare_domain(d2,d5) && !compare_domain(d3,d4)
     && !compare_domain(d3,d5) && !compare_domain(d4,d5)
    )
    println(io,"Compare fonctionnel, suite des tests\n")

    println(io,"---Test Union---\n")

    d1 = Domain([1], [3, 4], 1, 3)
    d2 = Domain([1, 2], [5, 6, 7], 2, 5)
    d3 = Domain([1, 2], [3, 4, 5, 6, 7], 2, 7)

    d4 = Domain([10], [3, 4, 5, 6], 3, 3)
    d5 = Domain([5, 6], [2, 4, 5, 7, 8], 2, 4)
    d6 = Domain([5, 6, 10], [2, 3, 4, 7, 8], 5, 7)

    if(compare_domain(union_domain(d1,d2),d3))
        println(io,"Union simple : OK\n")
    else
        println(io,"ERREUR : Union Simple")
        println(io,"----------------------------------")
        println(io,"d1 = ",d1)
        println(io,"d2 = ",d2)
        println(io,"d3 = ",d3)
        println(io,"dr = ",union_domain(d1,d2))
        println(io,"----------------------------------\n")
    end
    if(compare_domain(union_domain(d4,d5),d6))
        println(io,"Union avec multiples elem + cardinalités spéciales : OK\n")
    else
        println(io,"ERREUR : Union avec multiples elem + cardinalités spéciales")
        println(io,"----------------------------------")
        println(io,"d1 = ",d4)
        println(io,"d2 = ",d5)
        println(io,"d3 = ",d6)
        println(io,"dr = ",union_domain(d4,d5))
        println(io,"----------------------------------\n")
    end

    println(io,"---Test Intersect---\n")

    d1 = Domain([1], [3, 4], 1, 3)
    d2 = Domain([1, 2], [4, 5, 6], 2, 5)
    d3 = Domain([1], [4], 1, 2)

    d4 = Domain([10], [3, 4, 5, 6], 3, 3)
    d5 = Domain([5,6], [2, 4, 7, 8], 2, 4)
    d6 = Domain([], [4,5,6], 0, 3)

    if(compare_domain(intersect_domain(d1,d2),d3))
        println(io,"Intersect simple : OK\n")
    else
        println(io,"ERREUR : Intersect Simple")
        println(io,"----------------------------------")
        println(io,"d1 = ",d1)
        println(io,"d2 = ",d2)
        println(io,"d3 = ",d3)
        println(io,"dr = ",intersect_domain(d1,d2))
        println(io,"----------------------------------\n")
    end
    if(compare_domain(intersect_domain(d4,d5),d6))
        println(io,"Intersect avec multiples elem + cardinalités spéciales : OK\n")
    else
        println(io,"ERREUR : Intersect avec multiples elem + cardinalités spéciales")
        println(io,"----------------------------------")
        println(io,"d1 = ",d4)
        println(io,"d2 = ",d5)
        println(io,"d3 = ",d6)
        println(io,"dr = ",intersect_domain(d4,d5))
        println(io,"----------------------------------\n")
    end

    println(io,"---Test Difference---\n")

    d1 = Domain([1], [3, 4], 1, 3)
    d2 = Domain([1, 2], [4, 5, 6], 2, 5)
    d3 = Domain([2], [3,4,5,6], 1, 5)

    d4 = Domain([10], [3, 4, 5, 6], 3, 3)
    d5 = Domain([5, 6], [2, 4, 7, 8], 2, 4)
    d6 = Domain([10], [2, 3, 4, 5, 6, 7, 8], 1, 8)

    if(compare_domain(difference_domain(d1,d2),d3))
        println(io,"Difference simple : OK\n")
    else
        println(io,"ERREUR : Difference Simple")
        println(io,"----------------------------------")
        println(io,"d1 = ",d1)
        println(io,"d2 = ",d2)
        println(io,"d3 = ",d3)
        println(io,"dr = ",difference_domain(d1,d2))
        println(io,"----------------------------------\n")
    end
    if(compare_domain(difference_domain(d4,d5) ,d6))
        println(io,"Difference avec multiples elem + cardinalités spéciales : OK\n")
    else
        println(io,"ERREUR : Difference avec multiples elem + cardinalités spéciales")
        println(io,"----------------------------------")
        println(io,"d1 = ",d4)
        println(io,"d2 = ",d5)
        println(io,"d3 = ",d6)
        println(io,"dr = ",difference_domain(d4,d5))
        println(io,"----------------------------------\n")
    end

    println(io,"---Test Sous-Domaine---\n d2 sous-domaine de d1 ?")
    println(io,"---------------------------\n")

    d1 = Domain([4,5], [6], 2, 3)
    d2 = Domain([4,5], [], 2,2)

    print_domain(io, 1, [d1,d2])

    if(subDomain(d2,d1))
        println(io,"Prévu : d2 bien sous_domaine de d1")
    else
        println(io,"ERREUR : d2 n'est pas considéré comme sous_domaine de d1")
    end
    println(io,"---------------------------\n")


    d1 = Domain([4,5], [6], 2, 3)
    d2 = Domain([], [4,5], 0,2)

    print_domain(io, 1, [d1,d2])

    if(subDomain(d2,d1))
        println(io,"Prévu : d2 bien sous_domaine de d1")
    else
        println(io,"ERREUR : d2 n'est pas considéré comme sous_domaine de d1")
    end
    println(io,"---------------------------\n")

    d1 = Domain([4,5], [6], 2, 3)
    d2 = Domain([4,5], [2], 2,3)

    print_domain(io, 1, [d1,d2])

    if(subDomain(d2,d1))
        println(io,"Prévu : d2 bien sous_domaine de d1")
    else
        println(io,"ERREUR : d2 n'est pas considéré comme sous_domaine de d1")
    end
    println(io,"---------------------------\n")

    d1 = Domain([4,5], [6], 2, 3)
    d2 = Domain([], [2,3,4,5], 0,4)

    print_domain(io, 1, [d1,d2])

    if(subDomain(d2,d1))
        println(io,"Prévu : d2 bien sous_domaine de d1")
    else
        println(io,"ERREUR : d2 n'est pas considéré comme sous_domaine de d1")
    end
    println(io,"---------------------------\n")

    d1 = Domain([4,5], [6], 2, 3)
    d2 = Domain([4], [6], 1,2)

    print_domain(io, 1, [d1,d2])

    if(subDomain(d2,d1))
        println(io,"Prévu : d2 n'est pas sous_domaine de d1")
    else
        println(io,"ERREUR : d2 est considéré comme sous_domaine de d1")
    end
    println(io,"---------------------------\n")

    d1 = Domain([4,5,10,11], [6,7,8,9], 4, 6)
    d2 = Domain([], [2,3,4,5], 3,4)

    print_domain(io, 1, [d1,d2])

    if(subDomain(d2,d1))
        println(io,"Prévu : d2 n'est pas sous_domaine de d1")
    else
        println(io,"ERREUR : d2 est considéré comme sous_domaine de d1")
    end
    println(io,"---------------------------\n")

else
    println(io,"ERREUR : Compare_domain")
    println(io, "compare_domain(d1,d2) = ",compare_domain(d1,d2))
    println(io, "compare_domain(d1,d3) = ",compare_domain(d1,d3))
    println(io, "compare_domain(d1,d4) = ",compare_domain(d1,d4))
    println(io, "compare_domain(d1,d5) = ",compare_domain(d1,d5))
    println(io, "compare_domain(d2,d3) = ",compare_domain(d2,d3))
    println(io, "compare_domain(d2,d4) = ",compare_domain(d2,d4))
    println(io, "compare_domain(d2,d5) = ",compare_domain(d2,d5))
    println(io, "compare_domain(d3,d4) = ",compare_domain(d3,d4))
    println(io, "compare_domain(d3,d5) = ",compare_domain(d3,d5))
    println(io, "compare_domain(d4,d5) = ",compare_domain(d4,d5))

end



close(io)