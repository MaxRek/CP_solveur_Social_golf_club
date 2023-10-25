# fileName : name.mzn
# parameters : parameters contains p, g, w.
# breakingParallellism : booleans indicating if we put accessory constraints
function writer(fileName, parameters, breakingParallellism)
  open(fileName, "w") do file
    write(file, "int : p =" * string(parameters[1]) * ";\n")
    write(file, "int : g =" * string(parameters[2]) * ";\n")
    write(file, "int : w =" * string(parameters[3]) * ";\n")
    write(file, "int : q = p*g ;\n")
    write(file, "set of int : GOLFERS = 1..q;\nset of int : GROUPS = 1..g;\nset of int : WEEKS = 1..w;\narray[WEEKS, GROUPS] of var set of GOLFERS : E;\n")
    write(file, "constraint forall (i in WEEKS) (")
    
    for i in 1:(parameters[2]-1)
      write(file, "E[i," * string(i) * "] union ")
    end
    write(file, "E[i," * string(parameters[2]) * "]= GOLFERS ); \n")
    
    write(file, "constraint forall(x,y in GROUPS, i in 1..w-1, j in i+1..w) ( card(E[i,x] intersect E[j,y]) <= 1);\n")
    write(file, "constraint forall(i in WEEKS, j in GROUPS)( card(E[i,j]) = p);\n")
    if breakingParallellism
      write(file, supplementaryConstraints(fileName, parameters))
    end
    write(file, "solve satisfy;")
  end
  return true
end

function supplementaryConstraints(fileName, parameters)
  suppConstraints = "constraint forall (i in WEEKS) (   
    1 in E[i,1]
);

constraint forall (j in 1..g) (   
 forall (i in 1..p) (   
    ((j-1)*p)+i in E[1, j]
 )
);

constraint forall (i in 2..w) (   
  forall (j in 2..p) (   
    j in E[i,j]
  )
);

constraint forall (i in 2..w) (   
  p+(i-1) in E[i,1]
);"
  return suppConstraints
end

function generateModelsTests(maxG, maxP, maxW)
  for i in 1:maxP
    for j in 1:maxG
      for k in 1:maxW
        fileName="in/modeles/modelP"*string(i)*"G"*string(j)*"W"*string(k)
        writer(fileName*"Classic.mzn" , [i,j,k] , false)
        writer(fileName*"Ameliorated.mzn", [i,j,k] , true)
      end
    end
  end
end







