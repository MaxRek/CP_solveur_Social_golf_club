mutable struct Domain
    lb :: Vector{Int64}
    up :: Vector{Int64}
    minC :: Int64
    maxC :: Int64
end

mutable struct Constraint
    left :: Domain
    right :: Domain
    op :: String
end

mutable struct CSP
    X :: Vector{Int64}
    D :: Tuple{Domain}
    C :: Vector{Constraint}
end
