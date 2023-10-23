mutable struct Domain
    lb :: Vector{Int64}
    up :: Vector{Int64}
    minC :: Int64
    maxC :: Int64
end

mutable struct Constraint
    domains :: Vector{Int64}
    opérande :: String
    result :: Domain
end

mutable struct CSP
    X :: Vector{Int64}
    D :: Tuple{Domain}
    C :: Vector{Constraint}
end
