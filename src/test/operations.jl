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