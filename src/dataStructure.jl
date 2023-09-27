mutable struct Domain
    lb :: Vector{Int64}
    up :: Vector{Int64}
    minC :: Int64
    maxC :: Int64
end

mutable struct Constraint
    left :: Int64
    right :: Int64
    op :: String
end

mutable struct CSP
    X :: Vector{Int64}
    D :: Tuple{Int64,Int64}
    C :: Vector{Constraint}
end
