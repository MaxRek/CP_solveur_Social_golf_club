mutable struct Constraint
    domains :: Vector{Int64}
    operande :: String
    result :: Domain
end

mutable struct CSP
    X :: Vector{Int64}
    D :: Vector{Domain}
    C :: Vector{Constraint}
end
