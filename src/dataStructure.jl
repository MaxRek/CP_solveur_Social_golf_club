mutable struct Domain
    lb :: Vector{Int64}
    up :: Vector{Int64}
    minC :: Int64
    maxC :: Int64
end

mutable struct Constraint
<<<<<<< HEAD
    left :: Int64
    right :: Int64
    op :: String
=======
    domains :: Vector{Int64}
    operande :: String
>>>>>>> 2ba14193648ea4845c8d1df0b9938a88b6fb0057
    result :: Domain
end

mutable struct CSP
    X :: Vector{Int64}
    D :: Vector{Domain}
    C :: Vector{Constraint}
end
