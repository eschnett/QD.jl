# Types

const D4 = NTuple{4, Cdouble}

export Float256
struct Float256 <: AbstractFloat
    d4::D4
end



# Functions

function Base.tryparse(::Type{Float256}, str::String)
    r = tryparse(BigFloat, str)
    r === nothing && return r
    Float256(r)
end

export @f256_str
macro f256_str(str::String)
    :(Float256(BigFloat($str)))
end

# function Base.show(io::IO, x::Float256)
#     len = 80
#     buf = Vector{Cchar}(undef, len)
#     prec = 64
#     ccall((:c_qd_swrite, libqd), Cvoid, (Ref{D4}, Cint, Ptr{Cchar}, Cint),
#           x.d4, prec, buf, len)
#     print(io, unsafe_string(pointer(buf)))
# end

Base.show(io::IO, x::Float256) = show(io, BigFloat(x))



# function Float256(x::Float64)
#     r = Ref{D4}()
#     ccall((:c_qd_copy_d, libqd), Cvoid, (Cdouble, Ref{D4}), x, r)
#     Float256(r[])
# end
#
# function Float256(x::Float128)
#     r = Ref{D4}()
#     ccall((:c_qd_copy_dd, libqd), Cvoid, (Ref{D2}, Ref{D4}), x.d2, r)
#     Float256(r[])
# end

Float256(x::Float64) = Float256((x, 0.0, 0.0, 0.0))

Float256(x::Float128) = Float256((x.d2[1], x.d2[2], 0.0, 0.0))

function Float256(x::Union{Bool, Int8, Int16, Int32, UInt8, UInt16, UInt32,
                           Float16, Float32})
    Float256(Float64(x))
end

function Float256(x::Union{Int64, UInt64})
    hi = x >> 32 << 32
    lo = x - hi
    Float256(Float64(hi)) + Float256(Float64(lo))
end

function Float256(x::Rational)
    Float256(numerator(x)) / Float256(denominator(x))
end

function Float256(x::BigFloat)
    r1 = Float256(Float64(x))
    x -= BigFloat(r1)
    r2 = Float256(Float64(x))
    x -= BigFloat(r2)
    r3 = Float256(Float64(x))
    x -= BigFloat(r3)
    r4 = Float256(Float64(x))
    # x -= BigFloat(r4)
    r1 + r2 + r3 + r4
end

Base.Float64(x::Float256) = x.d4[1]

Float128(x::Float256) = Float128((x.d4[1], x.d4[2]))

Base.BigFloat(x::Float256) =
    big(x.d4[1]) + big(x.d4[2]) + big(x.d4[3]) + big(x.d4[4])

Base.big(::Type{Float256}) = BigFloat

Base.promote_rule(::Type{Float256}, ::Type{Float16}) = Float256
Base.promote_rule(::Type{Float256}, ::Type{Float32}) = Float256
Base.promote_rule(::Type{Float256}, ::Type{Float64}) = Float256
Base.promote_rule(::Type{Float256}, ::Type{Float128}) = Float256
Base.promote_rule(::Type{Float256}, ::Type{BigFloat}) = BigFloat
Base.promote_rule(::Type{Float256}, ::Type{I}) where {I <: Integer} = Float256
Base.promote_rule(::Type{Float256}, ::Type{BigInt}) = BigFloat



# Base.zero(::Type{Float256}) = c256_0
# Base.one(::Type{Float256}) = c256_1
# Base.eps(::Type{Float256}) = c256_eps
Base.zero(::Type{Float256}) = Float256(0.0)
Base.one(::Type{Float256}) = Float256(1.0)
Base.eps(::Type{Float256}) = Float256(2^-208)

# function Float256(::Irrational{:π})
#     r = Ref{D4}()
#     ccall((:c_qd_pi, libqd), Cvoid, (Ref{D4},), r)
#     Float256(r[])
# end
Float256(::Irrational{:ℯ}) = c256_e
Float256(::Irrational{:π}) = c256_pi



Base. +(x::Float256) = x

# function Base. -(x::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_neg, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
#     Float256(r[])
# end

function Base. -(a::Float256)
    Float256((- a.d4[1], - a.d4[2], - a.d4[3], - a.d4[4]))
end

# function Base.abs(x::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_abs, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
#     Float256(r[])
# end
Base.abs(a::Float256) = a.d4[1] < 0.0 ? -a : a

Base.inv(x::Float256) = one(Float64) / x



# function Base. +(x::Float256, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_add, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{D4}), x.d4, y.d4, r)
#     Float256(r[])
# end
#
# function Base. +(x::Float128, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_add_dd_qd, libqd), Cvoid, (Ref{D2}, Ref{D4}, Ref{D4}),
#           x.d2, y.d4, r)
#     Float256(r[])
# end
#
# function Base. +(x::Float64, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_add_d_qd, libqd), Cvoid, (Cdouble, Ref{D4}, Ref{D4}),
#           x, y.d4, r)
#     Float256(r[])
# end
#
# function Base. +(x::Float256, y::Float128)
#     r = Ref{D4}()
#     ccall((:c_qd_add_qd_dd, libqd), Cvoid, (Ref{D4}, Ref{D2}, Ref{D4}),
#           x.d4, y.d2, r)
#     Float256(r[])
# end
#
# function Base. +(x::Float256, y::Float64)
#     r = Ref{D4}()
#     ccall((:c_qd_add_qd_d, libqd), Cvoid, (Ref{D4}, Cdouble, Ref{D4}),
#           x.d4, y, r)
#     Float256(r[])
# end

function Base. +(a::Float256, b::Float256)
    s0, t0 = two_sum(a.d4[1], b.d4[1])
    s1, t1 = two_sum(a.d4[2], b.d4[2])
    s2, t2 = two_sum(a.d4[3], b.d4[3])
    s3, t3 = two_sum(a.d4[4], b.d4[4])

    s1, t0 = two_sum(s1, t0)
    s2, t0, t1 = three_sum(s2, t0, t1)
    s3, t0, t2 = three_sum2(s3, t0, t2)
    t0 = t0 + t1 + t3

    s0, s1, s2, s3, t0 = renorm(s0, s1, s2, s3, t0)
    Float256((s0, s1, s2, s3))
end

function Base. +(a::Float256, b::Float64)
    c0, e = two_sum(a.d4[1], b)
    c1, e = two_sum(a.d4[2], e)
    c2, e = two_sum(a.d4[3], e)
    c3, e = two_sum(a.d4[4], e)

    c0, c1, c2, c3, e = renorm(c0, c1, c2, c3, e)

    Float256((c0, c1, c2, c3))
end

function Base. +(a::Float256, b::Float128)
    s0, t0 = two_sum(a.d4[1], b.d2[1])
    s1, t1 = two_sum(a.d4[2], b.d2[2])

    s1, t0 = two_sum(s1, t0)

    s2 = a.d4[3]
    s2, t0, t1 = three_sum(s2, t0, t1)

    s3, t0 = two_sum(t0, a.d4[4])
    t0 += t1

    s0, s1, s2, s3, t0 = renorm(s0, s1, s2, s3, t0)
    Float256((s0, s1, s2, s3))
end

Base. +(a::Float128, b::Float256) = b + a
Base. +(a::Float64, b::Float256) = b + a



# function Base. -(x::Float256, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_sub, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{D4}), x.d4, y.d4, r)
#     Float256(r[])
# end
#
# function Base. -(x::Float128, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_sub_dd_qd, libqd), Cvoid, (Ref{D2}, Ref{D4}, Ref{D4}),
#           x.d2, y.d4, r)
#     Float256(r[])
# end
#
# function Base. -(x::Float64, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_sub_d_qd, libqd), Cvoid, (Cdouble, Ref{D4}, Ref{D4}),
#           x, y.d4, r)
#     Float256(r[])
# end
#
# function Base. -(x::Float256, y::Float128)
#     r = Ref{D4}()
#     ccall((:c_qd_sub_qd_dd, libqd), Cvoid, (Ref{D4}, Ref{D2}, Ref{D4}),
#           x.d4, y.d2, r)
#     Float256(r[])
# end
#
# function Base. -(x::Float256, y::Float64)
#     r = Ref{D4}()
#     ccall((:c_qd_sub_qd_d, libqd), Cvoid, (Ref{D4}, Cdouble, Ref{D4}),
#           x.d4, y, r)
#     Float256(r[])
# end

Base. -(a::Float256, b::Float256) = a + (- b)
Base. -(a::Float256, b::Float64) = a + (- b)
Base. -(a::Float256, b::Float128) = a + (- b)
Base. -(a::Float128, b::Float256) = a + (- b)
Base. -(a::Float64, b::Float256) = a + (- b)



# function Base. *(x::Float256, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_mul, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{D4}), x.d4, y.d4, r)
#     Float256(r[])
# end
#
# # This function as well as its counterpart below are much less
# # accurate than expected. Their accuracy is that of Float128, not
# # Float256. We therefore disable them.
# # function Base. *(x::Float128, y::Float256)
# #     r = Ref{D4}()
# #     ccall((:c_qd_mul_dd_qd, libqd), Cvoid, (Ref{D2}, Ref{D4}, Ref{D4}),
# #           x.d2, y.d4, r)
# #     Float256(r[])
# # end
#
# function Base. *(x::Float64, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_mul_d_qd, libqd), Cvoid, (Cdouble, Ref{D4}, Ref{D4}),
#           x, y.d4, r)
#     Float256(r[])
# end
#
# # function Base. *(x::Float256, y::Float128)
# #     r = Ref{D4}()
# #     ccall((:c_qd_mul_qd_dd, libqd), Cvoid, (Ref{D4}, Ref{D2}, Ref{D4}),
# #           x.d4, y.d2, r)
# #     Float256(r[])
# # end
#
# function Base. *(x::Float256, y::Float64)
#     r = Ref{D4}()
#     ccall((:c_qd_mul_qd_d, libqd), Cvoid, (Ref{D4}, Cdouble, Ref{D4}),
#           x.d4, y, r)
#     Float256(r[])
# end

function Base. *(a::Float256, b::Float256)
    # sloppy_mul
    # quad-double * quad-double
    # a0 * b0                    0
    #      a0 * b1               1
    #      a1 * b0               2
    #           a0 * b2          3
    #           a1 * b1          4
    #           a2 * b0          5
    #                a0 * b3     6
    #                a1 * b2     7
    #                a2 * b1     8
    #                a3 * b0     9

    p0, q0 = two_prod(a.d4[1], b.d4[1])

    p1, q1 = two_prod(a.d4[1], b.d4[2])
    p2, q2 = two_prod(a.d4[2], b.d4[1])

    p3, q3 = two_prod(a.d4[1], b.d4[3])
    p4, q4 = two_prod(a.d4[2], b.d4[2])
    p5, q5 = two_prod(a.d4[3], b.d4[1])

    # Start Accumulation
    p1, p2, q0 = three_sum(p1, p2, q0)

    # Six-Three Sum  of p2, q1, q2, p3, p4, p5.
    p2, q1, q2 = three_sum(p2, q1, q2)
    p3, p4, p5 = three_sum(p3, p4, p5)
    # compute (s0, s1, s2) = (p2, q1, q2) + (p3, p4, p5).
    s0, t0 = two_sum(p2, p3)
    s1, t1 = two_sum(q1, p4)
    s2 = q2 + p5
    s1, t0 = two_sum(s1, t0)
    s2 += t0 + t1

    # O(eps^3) order terms
    s1 += a.d4[1] * b.d4[4] + a.d4[2] * b.d4[3] + a.d4[3] * b.d4[2] +
        a.d4[4] * b.d4[1] + q0 + q3 + q4 + q5
    p0, p1, s0, s1, s2 = renorm(p0, p1, s0, s1, s2)
    return Float256((p0, p1, s0, s1))
end

# This function is much less accurate than expected. Their accuracy is
# that of Float128, not Float256. We therefore disable it.
# function Base. *(a::Float256, b::Float128)
#     # quad-double * double-double
#     # a0 * b0                        0
#     #      a0 * b1                   1
#     #      a1 * b0                   2
#     #           a1 * b1              3
#     #           a2 * b0              4
#     #                a2 * b1         5
#     #                a3 * b0         6
#     #                     a3 * b1    7
#
#     p0, q0 = two_prod(a.d4[1], b.d2[1])
#     p1, q1 = two_prod(a.d4[1], b.d2[2])
#     p2, q2 = two_prod(a.d4[2], b.d2[1])
#     p3, q3 = two_prod(a.d4[2], b.d2[2])
#     p4, q4 = two_prod(a.d4[3], b.d2[1])
#
#     p1, p2, q0 = three_sum(p1, p2, q0)
#
#     # Five-Three-Sum
#     p2, p3, p4 = three_sum(p2, p3, p4)
#     q1, q2 = two_sum(q1, q2)
#     s0, t0 = two_sum(p2, q1)
#     s1, t1 = two_sum(p3, q2)
#     s1, t0 = two_sum(s1, t0)
#     s2 = t0 + t1 + p4
#     p2 = s0
#
#     p3 = a.d4[3] * b.d2[1] + a.d4[4] * b.d2[2] + q3 + q4
#     p3, q0, s1 = three_sum2(p3, q0, s1)
#     p4 = q0 + s2
#
#     p0, p1, p2, p3, p4 = renorm(p0, p1, p2, p3, p4)
#     Float256((p0, p1, p2, p3))
# end

# This is an adaptation from the *(::Float256, ::Float256) case,
# manually partially evaluated to avoid operations involving zeros.
function Base. *(a::Float256, b::Float128)
    # sloppy_mul
    # quad-double * quad-double
    # a0 * b0                    0
    #      a0 * b1               1
    #      a1 * b0               2
    #           a1 * b1          4
    #           a2 * b0          5
    #                a2 * b1     8
    #                a3 * b0     9

    p0, q0 = two_prod(a.d4[1], b.d2[1])

    p1, q1 = two_prod(a.d4[1], b.d2[2])
    p2, q2 = two_prod(a.d4[2], b.d2[1])

    p4, q4 = two_prod(a.d4[2], b.d2[2])
    p5, q5 = two_prod(a.d4[3], b.d2[1])

    # Start Accumulation
    p1, p2, q0 = three_sum(p1, p2, q0)

    # Six-Three Sum  of p2, q1, q2, p3, p4, p5.
    p2, q1, q2 = three_sum(p2, q1, q2)
    p3, p4 = two_sum(p4, p5)
    # compute (s0, s1, s2) = (p2, q1, q2) + (p3, p4, p5).
    s0, t0 = two_sum(p2, p3)
    s1, t1 = two_sum(q1, p4)
    s2 = q2
    s1, t0 = two_sum(s1, t0)
    s2 += t0 + t1

    # O(eps^3) order terms
    s1 += a.d4[3] * b.d2[2] + a.d4[4] * b.d2[1] + q0 + q4 + q5
    p0, p1, s0, s1, s2 = renorm(p0, p1, s0, s1, s2)
    return Float256((p0, p1, s0, s1))
end

function Base. *(a::Float256, b::Float64)
    p0, q0 = two_prod(a.d4[1], b)
    p1, q1 = two_prod(a.d4[2], b)
    p2, q2 = two_prod(a.d4[3], b)
    p3 = a.d4[4] * b

    s0 = p0

    s1, s2 = two_sum(q0, p1)

    s2, q1, p2 = three_sum(s2, q1, p2)

    q1, q2, p3 = three_sum2(q1, q2, p3)
    s3 = q1

    s4 = q2 + p2

    s0, s1, s2, s3, s4 = renorm(s0, s1, s2, s3, s4)
    Float256((s0, s1, s2, s3))
end

Base. *(a::Float64, b::Float256) = b * a
Base. *(a::Float128, b::Float256) = b * a



function Base. /(x::Float256, y::Float256)
    r = Ref{D4}()
    ccall((:c_qd_div, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{D4}), x.d4, y.d4, r)
    Float256(r[])
end

# function Base. /(x::Float128, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_div_dd_qd, libqd), Cvoid, (Ref{D2}, Ref{D4}, Ref{D4}),
#           x.d2, y.d4, r)
#     Float256(r[])
# end
#
# function Base. /(x::Float64, y::Float256)
#     r = Ref{D4}()
#     ccall((:c_qd_div_d_qd, libqd), Cvoid, (Cdouble, Ref{D4}, Ref{D4}),
#           x, y.d4, r)
#     Float256(r[])
# end
#
# function Base. /(x::Float256, y::Float128)
#     r = Ref{D4}()
#     ccall((:c_qd_div_qd_dd, libqd), Cvoid, (Ref{D4}, Ref{D2}, Ref{D4}),
#           x.d4, y.d2, r)
#     Float256(r[])
# end
#
# function Base. /(x::Float256, y::Float64)
#     r = Ref{D4}()
#     ccall((:c_qd_div_qd_d, libqd), Cvoid, (Ref{D4}, Cdouble, Ref{D4}),
#           x.d4, y, r)
#     Float256(r[])
# end

Base. \(x::Float256, y::Float256) = y / x
# Base. \(x::Float128, y::Float256) = y / x
# Base. \(x::Float64, y::Float256) = y / x
# Base. \(x::Float256, y::Float128) = y / x
# Base. \(x::Float256, y::Float64) = y / x



function Base.cmp(x::Float256, y::Float256)
    r = Ref{Cint}()
    ccall((:c_qd_comp, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{Cint}),
          x.d4, y.d4, r)
    Int(r[])
end

function Base.cmp(x::Float64, y::Float256)
    r = Ref{Cint}()
    ccall((:c_qd_comp_d_qd, libqd), Cvoid, (Cdouble, Ref{D4}, Ref{Cint}),
          x, y.d4, r)
    Int(r[])
end

function Base.cmp(x::Float256, y::Float64)
    r = Ref{Cint}()
    ccall((:c_qd_comp_qd_d, libqd), Cvoid, (Ref{D4}, Cdouble, Ref{Cint}),
          x.d4, y, r)
    Int(r[])
end

# Base. ==(x::Float256, y::Float256) = cmp(x, y) == 0
# Base. ==(x::Float64, y::Float256) = cmp(x, y) == 0
# Base. ==(x::Float256, y::Float64) = cmp(x, y) == 0
#
# Base. !=(x::Float256, y::Float256) = cmp(x, y) != 0
# Base. !=(x::Float64, y::Float256) = cmp(x, y) != 0
# Base. !=(x::Float256, y::Float64) = cmp(x, y) != 0
#
# Base. <(x::Float256, y::Float256) = cmp(x, y) < 0
# Base. <(x::Float64, y::Float256) = cmp(x, y) < 0
# Base. <(x::Float256, y::Float64) = cmp(x, y) < 0
#
# Base. <=(x::Float256, y::Float256) = cmp(x, y) <= 0
# Base. <=(x::Float64, y::Float256) = cmp(x, y) <= 0
# Base. <=(x::Float256, y::Float64) = cmp(x, y) <= 0
#
# Base. >(x::Float256, y::Float256) = cmp(x, y) > 0
# Base. >(x::Float64, y::Float256) = cmp(x, y) > 0
# Base. >(x::Float256, y::Float64) = cmp(x, y) > 0
#
# Base. >=(x::Float256, y::Float256) = cmp(x, y) >= 0
# Base. >=(x::Float64, y::Float256) = cmp(x, y) >= 0
# Base. >=(x::Float256, y::Float64) = cmp(x, y) >= 0

Base. ==(a::Float256, b::Float256) =
    a.d4[1] == b.d4[1] && a.d4[2] == b.d4[2] &&
    a.d4[3] == b.d4[3] && a.d4[4] == b.d4[4]
Base. ==(a::Float128, b::Float256) = b == a
Base. ==(a::Float64, b::Float256) = b == a
Base. ==(a::Float256, b::Float128) =
    a.d4[1] == b.d2[1] && a.d4[2] == b.d2[2] && a.d4[3] == 0.0 && a.d4[4] == 0.0
Base. ==(a::Float256, b::Float64) =
    a.d4[1] == b && a.d4[2] == 0.0 && a.d4[3] == 0.0 && a.d4[4] == 0.0

Base. !=(a::Float256, b::Float256) = !(a == b)
Base. !=(a::Float128, b::Float256) = !(a == b)
Base. !=(a::Float64, b::Float256) = !(a == b)
Base. !=(a::Float256, b::Float128) = !(a == b)
Base. !=(a::Float256, b::Float64) = !(a == b)

Base. <(a::Float256, b::Float256) =
    a.d4[1] < b.d4[1] ||
    (a.d4[1] == b.d4[1] && (a.d4[2] < b.d4[2] ||
                            (a.d4[2] == b.d4[2] && (a.d4[3] < b.d4[3] ||
                                                    (a.d4[3] == b.d4[3] &&
                                                     a.d4[4] < b.d4[4])))))
Base. <(a::Float128, b::Float256) = b > a
Base. <(a::Float64, b::Float256) = b > a
Base. <(a::Float256, b::Float128) =
    a.d4[1] < b.d2[1] ||
    (a.d4[1] == b.d2[1] && (a.d4[2] < b.d2[2] ||
                            (a.d4[2] == b.d2[2] && a.d4[3] < 0.0)))
Base. <(a::Float256, b::Float64) =
    a.d4[1] < b || (a.d4[1] == b && a.d4[2] < 0.0)

Base. <=(a::Float256, b::Float256) =
    a.d4[1] < b.d4[1] ||
    (a.d4[1] == b.d4[1] && (a.d4[2] < b.d4[2] ||
                            (a.d4[2] == b.d4[2] && (a.d4[3] < b.d4[3] ||
                                                    (a.d4[3] == b.d4[3] &&
                                                     a.d4[4] <= b.d4[4])))))
Base. <=(a::Float128, b::Float256) = b >= a
Base. <=(a::Float64, b::Float256) = b >= a
Base. <=(a::Float256, b::Float128) =
    a.d4[1] < b.d2[1] ||
    (a.d4[1] == b.d2[1] && (a.d4[2] < b.d2[2] ||
                            (a.d4[2] == b.d2[2] && a.d4[3] <= 0.0)))
Base. <=(a::Float256, b::Float64) =
    a.d4[1] < b || (a.d4[1] == b && a.d4[2] <= 0.0)

Base. >(a::Float256, b::Float256) =
    a.d4[1] > b.d4[1] ||
    (a.d4[1] == b.d4[1] && (a.d4[2] > b.d4[2] ||
                            (a.d4[2] == b.d4[2] && (a.d4[3] > b.d4[3] ||
                                                    (a.d4[3] == b.d4[3] &&
                                                     a.d4[4] > b.d4[4])))))
Base. >(a::Float128, b::Float256) = b < a
Base. >(a::Float64, b::Float256) = b < a
Base. >(a::Float256, b::Float128) =
    a.d4[1] > b.d2[1] ||
    (a.d4[1] == b.d2[1] && (a.d4[2] > b.d2[2] ||
                            (a.d4[2] == b.d2[2] && a.d4[3] > 0.0)))
Base. >(a::Float256, b::Float64) =
    a.d4[1] > b || (a.d4[1] == b && a.d4[2] > 0.0)

Base. >=(a::Float256, b::Float256) =
    a.d4[1] > b.d4[1] ||
    (a.d4[1] == b.d4[1] && (a.d4[2] > b.d4[2] ||
                            (a.d4[2] == b.d4[2] && (a.d4[3] > b.d4[3] ||
                                                    (a.d4[3] == b.d4[3] &&
                                                     a.d4[4] >= b.d4[4])))))
Base. >=(a::Float128, b::Float256) = b <= a
Base. >=(a::Float64, b::Float256) = b <= a
Base. >=(a::Float256, b::Float128) =
    a.d4[1] > b.d2[1] ||
    (a.d4[1] == b.d2[1] && (a.d4[2] > b.d2[2] ||
                            (a.d4[2] == b.d2[2] && a.d4[3] >= 0.0)))
Base. >=(a::Float256, b::Float64) =
    a.d4[1] > b || (a.d4[1] == b && a.d4[2] >= 0.0)



function Base.ceil(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_ceil, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.floor(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_floor, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

# Note: This breaks ties the wrong way
function Base.round(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_nint, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.trunc(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_aint, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end



function Base. ^(x::Float256, i::Integer)
    r = Ref{D4}()
    ccall((:c_qd_npwr, libqd), Cvoid, (Ref{D4}, Cint, Ref{D4}), x.d4, i, r)
    Float256(r[])
end

# function Base.literal_pow(::typeof(^), x::Float256, ::Val{2})
#     r = Ref{D4}()
#     ccall((:c_qd_sqr, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
#     Float256(r[])
# end

function Base.literal_pow(::typeof(^), a::Float256, ::Val{2})
    # quad-double ^ 2  = (x0 + x1 + x2 + x3) ^ 2
    #                  = x0 ^ 2 + 2 x0 * x1 + (2 x0 * x2 + x1 ^ 2)
    #                             + (2 x0 * x3 + 2 x1 * x2)

    p0, q0 = two_sqr(a.d4[1])
    p1, q1 = two_prod(2.0 * a.d4[1], a.d4[2])
    p2, q2 = two_prod(2.0 * a.d4[1], a.d4[3])
    p3, q3 = two_sqr(a.d4[2])

    p1, q0 = two_sum(q0, p1)

    q0, q1 = two_sum(q0, q1)
    p2, p3 = two_sum(p2, p3)

    s0, t0 = two_sum(q0, p2)
    s1, t1 = two_sum(q1, p3)

    s1, t0 = two_sum(s1, t0)
    t0 += t1

    s1, t0 = quick_two_sum(s1, t0)
    p2, t1 = quick_two_sum(s0, s1)
    p3, q0 = quick_two_sum(t1, t0)

    p4 = 2.0 * a.d4[1] * a.d4[4]
    p5 = 2.0 * a.d4[2] * a.d4[3]

    p4, p5 = two_sum(p4, p5)
    q2, q3 = two_sum(q2, q3)

    t0, t1 = two_sum(p4, q2)
    t1 = t1 + p5 + q3

    p3, p4 = two_sum(p3, t0)
    p4 = p4 + q0 + t1

    p0, p1, p2, p3, p4 = renorm(p0, p1, p2, p3, p4)
    Float256((p0, p1, p2, p3))
end

function Base.sqrt(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_sqrt, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

export nroot
function nroot(x::Float256, i::Integer)
    r = Ref{D4}()
    ccall((:c_qd_nroot, libqd), Cvoid, (Ref{D4}, Cint, Ref{D4}), x.d4, i, r)
    Float256(r[])
end

function Base.exp(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_exp, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

Base.exp10(x::Float256) = exp(c256_log10 * x)

Base.exp2(x::Float256) = exp(c256_log2 * x)

function Base.log(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_log, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.log10(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_log10, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

Base.log2(x::Float256) = c256_1_log2 * log(x)

function Base.sin(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_sin, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.cos(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_cos, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.tan(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_tan, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.asin(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_asin, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.acos(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_acos, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.atan(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_atan, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.atan(x::Float256, y::Float256)
    r = Ref{D4}()
    ccall((:c_qd_atan2, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{D4}),
          x.d4, y.d4, r)
    Float256(r[])
end

Base.hypot(x::Float256, y::Float256) = sqrt(x^2 + y^2)

function Base.sinh(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_sinh, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.cosh(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_cosh, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.tanh(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_tanh, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.asinh(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_asinh, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.acosh(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_acosh, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.atanh(x::Float256)
    r = Ref{D4}()
    ccall((:c_qd_atanh, libqd), Cvoid, (Ref{D4}, Ref{D4}), x.d4, r)
    Float256(r[])
end

function Base.sincos(x::Float256)
    r = Ref{D4}()
    s = Ref{D4}()
    ccall((:c_qd_sincos, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{D4}), x.d4, r, s)
    Float256(r[]), Float256(s[])
end

export sincosh
function sincosh(x::Float256)
    r = Ref{D4}()
    s = Ref{D4}()
    ccall((:c_qd_sincosh, libqd), Cvoid, (Ref{D4}, Ref{D4}, Ref{D4}),
          x.d4, r, s)
    Float256(r[]), Float256(s[])
end



function Base.rand(::Type{Float256})
    r = Ref{D4}()
    ccall((:c_qd_rand, libqd), Cvoid, (Ref{D4},), r)
    Float256(r[])
end

function Base.rand(::Type{Float256}, dims::Dims)
    r = Array{Float256}(undef, dims)
    for i in LinearIndices(r)
        r[i] = rand(Float256)
    end
    r
end

Base.rand(::Type{Float256}, dims::Integer...) = rand(Float256, Dims(dims))



# Constants

# const c256_0 = Float256(0.0)
# const c256_1 = Float256(1.0)
# const c256_eps = Float256(2^-208)

const c256_pi = begin
    r = Ref{D4}()
    ccall((:c_qd_pi, libqd), Cvoid, (Ref{D4},), r)
    Float256(r[])
end
const c256_e = exp(Float256(1.0))
const c256_log10 = log(Float256(10.0))
const c256_log2 = log(Float256(2.0))
const c256_1_log2 = inv(c256_log2)
