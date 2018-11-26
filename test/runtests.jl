using Test
using QD

function approxeq(::Type{T}, tolfac, xs, r0, r1) where {T}
    tol = max(1, abs.(big.(xs))..., abs(r0), abs(r1))
    iseq = abs(r0 - r1) <= tolfac * tol * big(eps(T))
    if !iseq
        @show T tolfac xs r0 r1 abs(r0 - r1)
    end
    iseq
end

include("test128.jl")
include("test256.jl")
