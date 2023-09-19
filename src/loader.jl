function loading_G()

    G = Vector{Function}()

    println("G initialisé, \n Choisir le fichier à charger :")
    # recupere tous les fichiers se trouvant dans le repertoire cible
        allfiles = readdir("in/")
   
    # vecteur booleen qui marque les noms de fichiers valides
    flag = trues(size(allfiles))
    
        k=1
        for f in allfiles
            # traite chaque fichier du repertoire
            
            println(f[1])
            if (f[1] == 'G')
                # fichier G
            else
                # autre fichier => supprimer
                flag[k] = false
            end
            k = k+1
        end
    
        fg = allfiles[flag]
        #println(fg)
        #println(size(fg)[1])
        #println(typeof(fg))
        #println(typeof(fg[1]))

        if fg != []
            println(fg)
            println("Choissisez le dossier à charger (numéroté de 1 ",size(fg)[1],")") 
            n = parse(Int,readline())
            include(string("In/",fg[n]))
        else
            println("Erreur : Pas de fichier pour charger fonctions de filtrage, veuillez mettre un fichier commençant par \"G\" dans \"in\"")
            G = "E"
        end
    return(G)
end

function loading_split()
    println("split")
end