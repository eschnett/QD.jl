module QD

using Libdl

# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("QD not installed properly, run Pkg.build(\"QD\"), restart Julia, and try again")
end
include(depsjl_path)

# Module initialization function
function __init__()
    # Always check your dependencies from `deps.jl`
    check_deps()
end



# TODO: Check whether this is actually true
const fma_is_fast = true



# Basic (internal) Functions

# Computes fl(a+b) and err(a+b).  Assumes |a| >= |b|.
function quick_two_sum(a::T, b::T) where {T <: AbstractFloat}
    s = a + b
    err = b - (s - a)
    s, err
end

# Computes fl(a-b) and err(a-b).  Assumes |a| >= |b|.
function quick_two_diff(a::T, b::T) where {T <: AbstractFloat}
    s = a - b
    err = (a - s) - b
    s, err
end

# Computes fl(a+b) and err(a+b).
function two_sum(a::T, b::T) where {T <: AbstractFloat}
    s = a + b
    bb = s - a
    err = (a - (s - bb)) + (b - bb)
    s, err
end

# Computes fl(a-b) and err(a-b).
function two_diff(a::T, b::T) where {T <: AbstractFloat}
    s = a - b
    bb = s - a
    err = (a - (s - bb)) - (b + bb)
    s, err
end

# Computes high word and lo word of a
function split(a::T) where {T <: AbstractFloat}
    _QD_SPLITTER = 134217729.0               # = 2^27 + 1
    _QD_SPLIT_THRESH = 6.69692879491417e+299 # = 2^996
    if a > _QD_SPLIT_THRESH || a < -_QD_SPLIT_THRESH
        a *= 3.7252902984619140625e-09 # 2^-28
        temp = _QD_SPLITTER * a
        hi = temp - (temp - a)
        lo = a - hi
        hi *= 268435456.0       # 2^28
        lo *= 268435456.0       # 2^28
    else
        temp = _QD_SPLITTER * a
        hi = temp - (temp - a)
        lo = a - hi
    end
    hi, lo
end

# Computes fl(a*b) and err(a*b).
function two_prod(a::T, b::T) where {T <: AbstractFloat}
    if fma_is_fast
        p = a * b
        err = fma(a, b, -p)
    else
        p = a * b
        a_hi, a_lo = split(a)
        b_hi, b_lo = split(b)
        err = ((a_hi * b_hi - p) + a_hi * b_lo + a_lo * b_hi) + a_lo * b_lo
    end
    p, err
end

# Computes fl(a*a) and err(a*a).  Faster than the above method.
function two_sqr(a::T) where {T <: AbstractFloat}
    if fma_is_fast
        p = a * a
        err = fma(a, a, - p)
        p, err
    else
        q = a * a
        hi, lo = split(a)
        err = ((hi * hi - q) + 2.0 * hi * lo) + lo * lo
        q, err
    end
end



# Additions

function three_sum(a::T, b::T, c::T) where {T <: AbstractFloat}
    t1, t2 = two_sum(a, b)
    a , t3 = two_sum(c, t1)
    b , c  = two_sum(t2, t3)
    a, b, c
end

function three_sum2(a::T, b::T, c::T) where {T <: AbstractFloat}
    t1, t2 = two_sum(a, b)
    a , t3 = two_sum(c, t1)
    b = t2 + t3
    a, b, c
end

# Renormalization
function quick_renorm(c0::T, c1::T, c2::T, c3::T, c4::T) where
        {T <: AbstractFloat}
    s , t3 = quick_two_sum(c3, c4)
    s , t2 = quick_two_sum(c2, s )
    s , t1 = quick_two_sum(c1, s )
    c0, t0 = quick_two_sum(c0, s )

    s , t2 = quick_two_sum(t2, t3)
    s , t1 = quick_two_sum(t1, s )
    c1, t0 = quick_two_sum(t0, s )

    s , t1 = quick_two_sum(t1, t2)
    c2, t0 = quick_two_sum(t0, s )

    c3 = t0 + t1

    c0, c1, c2, c3, c4
end

function renorm(c0::T, c1::T, c2::T, c3::T) where {T <: AbstractFloat}
    s2 = 0.0
    s3 = 0.0

    isinf(c0) && return c0, c1, c2, c3

    s0, c3 = quick_two_sum(c2, c3)
    s0, c2 = quick_two_sum(c1, s0)
    c0, c1 = quick_two_sum(c0, s0)

    s0 = c0
    s1 = c1
    if s1 != 0.0
        s1, s2 = quick_two_sum(s1, c2)
        if s2 != 0.0
            s2, s3 = quick_two_sum(s2, c3)
        else
            s1, s2 = quick_two_sum(s1, c3)
        end
    else
        s0, s1 = quick_two_sum(s0, c2)
        if s1 != 0.0
            s1, s2 = quick_two_sum(s1, c3)
        else
            s0, s1 = quick_two_sum(s0, c3)
        end
    end

    c0 = s0
    c1 = s1
    c2 = s2
    c3 = s3

    c0, c1, c2, c3
end

function renorm(c0::T, c1::T, c2::T, c3::T, c4::T) where {T <: AbstractFloat}
    s2 = 0.0
    s3 = 0.0

    isinf(c0) && return c0, c1, c2, c3, c4

    s0, c4 = quick_two_sum(c3, c4)
    s0, c3 = quick_two_sum(c2, s0)
    s0, c2 = quick_two_sum(c1, s0)
    c0, c1 = quick_two_sum(c0, s0)

    s0 = c0
    s1 = c1

    if s1 != 0.0
        s1, s2 = quick_two_sum(s1, c2)
        if s2 != 0.0
            s2, s3 = quick_two_sum(s2, c3)
            if s3 != 0.0
                s3 += c4
            else
                s2, s3 = quick_two_sum(s2, c4)
            end
        else
            s1, s2 = quick_two_sum(s1, c3)
            if s2 != 0.0
                s2, s3 = quick_two_sum(s2, c4)
            else
                s1, s2 = quick_two_sum(s1, c4)
            end
        end
    else
        s0, s1 = quick_two_sum(s0, c2)
        if s1 != 0.0
            s1, s2 = quick_two_sum(s1, c3)
            if s2 != 0.0
                s2, s3 = quick_two_sum(s2, c4)
            else
                s1, s2 = quick_two_sum(s1, c4)
            end
        else
            s0, s1 = quick_two_sum(s0, c3)
            if s1 != 0.0
                s1, s2 = quick_two_sum(s1, c4)
            else
                s0, s1 = quick_two_sum(s0, c4)
            end
        end
    end

    c0 = s0
    c1 = s1
    c2 = s2
    c3 = s3

    c0, c1, c2, c3, c4
end



include("QD128.jl")
include("QD256.jl")

end
