    # --------------------------------------------------------------------------- #
# collect the un-hidden filenames available in a given folder

function getfname(pathtofolder)

    # recupere tous les fichiers se trouvant dans le repertoire cible
    allfiles = readdir(pathtofolder)

    # vecteur booleen qui marque les noms de fichiers valides
    flag = trues(size(allfiles))

    k=1
    for f in allfiles
        # traite chaque fichier du repertoire
        if f[1] != '.'
            # pas un fichier cache => conserver
            println("fname = ", f)
        else
            # fichier cache => supprimer
            flag[k] = false
        end
        k = k+1
    end

    # extrait les noms valides et retourne le vecteur correspondant
    finstances = allfiles[flag]
    return finstances
end

# --------------------------------------------------------------------------- #
# Loading an instance of CP (format: OR-library)

function loadCP(fname)
    println(fname)
    r = CSP(Vector{Int64}(),Vector{Domain}(),Vector{Constraint}())
    f=open(fname)

    #players
    line = readline(f)
    p = parse(Int,line[length(line)-1])
    
    #groups
    line = readline(f)
    g = parse(Int,line[length(line)-1])

    #weeks
    line = readline(f)
    w = parse(Int,line[length(line)-1])

    q = p*g

    golfers = collect(1:q)
    groups = collect(1:g)
    weeks = collect(1:w)

    #noms domaines
    r.X = collect(1:g*w)
    #domains
    for i in r.X
        push!(r.D, Domain(Vector{Int64}(),copy(golfers),0,p))
    end

    while(!eof(f) && !contains(line,"constraint"))
        line = readline(f)
    end

    #Contraintes
    #pour chaque semaines, tous les joueurs jouent
    for i in weeks
        push!(r.C,Constraint(r.D[collect((i-1)*g+1:i*g)],"union",Domain(collect(1:q),Vector{Int64}(),q,q)))
    end

    #pour chaque semaine, tous les groupes sont remplis
    for i in weeks
        for j in groups
            push!(r.C,Constraint(r.D[Vector{Int64}([i*j])],"cardinalities",Domain(Vector{Int64}(),Vector{Int64}(),p,p)))
        end
    end

    #pour chaque semaine, pour chaque groupe, il y a au plus une seule intersection entre deux groupes
    if w > 1
        if g > 1
            for x in 1:g-1
                for y in x:g
                    for i in 1:w-1
                        for j in i+1:w
                            push!(r.C,Constraint(r.D[Vector{Int64}([(i-1)*g + x,(j-1)*g + y])],"intersect",Domain(Vector{Int64}(),Vector{Int64}(collect(1:q)),0,1)))
                        end 
                    end
                end
            end
         end
    end

    if(contains(fname,"Ameliorated"))
        # Pour chaque semaine, le premier groupe contient le joueur 1
        for i in weeks
            push!(r.C,Constraint(r.D[Vector{Int64}([(i-1)*g+1])],"intersect",Domain(Vector{Int64}([1]),Vector{Int64}(),1,1)))
        end

        # Initialisation de la première ligne
        for i in 1:g
            push!(r.C,Constraint(r.D[Vector{Int64}([i])],"intersect",Domain(Vector{Int64}(collect((i-1)*p+1:i*p)),Vector{Int64}(),p,p)))
        end

        # Pour chaque semaine apres la premiere, du second au dernier joueur, il sera toujours dans le même groupe de la semaine
        for i in 2:w
            for j in 2:p
                push!(r.C, Constraint(r.D[Vector{Int64}([(i-1)*g + j])], "intersect", Domain(Vector{Int64}([j]),Vector{Int64}(),1,1)))
            end
        end

        # POur chaque semaine apres la première, le joueur = nb de joueurs + numéro de la semaine se retrouve dans le premier gourpe de la semaine
        for i in 2:w
            push!(r.C, Constraint(r.D[Vector{Int64}([g*(i-1)+1])], "intersect", Domain(Vector{Int64}([p+(i-1)]),Vector{Int64}(),1,1)))
        end
    end

    return r
end