# Types

const D2 = NTuple{2, Cdouble} 

export Float128
struct Float128 <: AbstractFloat
    d2::D2
end



# Functions

function Base.show(io::IO, x::Float128)
    len = 40
    buf = Vector{Cchar}(undef, len)
    prec = 32
    ccall((:c_dd_swrite, libqd), Cvoid, (Ref{D2}, Cint, Ptr{Cchar}, Cint),
          x.d2, prec, buf, len)
    print(io, unsafe_string(pointer(buf)))
end



function Float128(x::Float64)
    r = Ref{D2}()
    ccall((:c_dd_copy_d, libqd), Cvoid, (Cdouble, Ref{D2}), x, r)
    Float128(r[])
end
function Float128(x::Union{Int8, Int16, Int32, UInt8, UInt16, UInt32,
                           Float16, Float32})
    Float128(Float64(x))
end
function Float128(x::Union{Int64, UInt64})
    hi = x >> 32 << 32
    lo = x - hi
    Float128(Float64(hi)) + Float128(Float64(lo))
end
function Float128(x::BigFloat)
    r1 = Float128(Float64(x))
    x -= BigFloat(r1)
    r2 = Float128(Float64(x))
    # x -= BigFloat(r2)
    r1 + r2
end

Base.Float64(x::Float128) = x.d2[1]
Base.BigFloat(x::Float128) = big(x.d2[1]) + big(x.d2[2])

Base.big(::Type{Float128}) = Float256

Base.promote_rule(::Type{Float128}, ::Type{Float16}) = Float128
Base.promote_rule(::Type{Float128}, ::Type{Float32}) = Float128
Base.promote_rule(::Type{Float128}, ::Type{Float64}) = Float128
Base.promote_rule(::Type{Float128}, ::Type{BigFloat}) = BigFloat
Base.promote_rule(::Type{Float128}, ::Type{I}) where {I <: Integer} = Float128
Base.promote_rule(::Type{Float128}, ::Type{BigInt}) = BigFloat



function Float128(::Irrational{:π})
    r = Ref{D2}()
    ccall((:c_dd_pi, libqd), Cvoid, (Ref{D2},), r)
    Float128(r[])
end
Float128(::Irrational{:ℯ}) = c128_e
Base.zero(::Type{Float128}) = c128_0
Base.one(::Type{Float128}) = c128_1
Base.eps(::Type{Float128}) = c128_eps



Base. +(x::Float128) = x

function Base. -(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_neg, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.abs(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_abs, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

Base.inv(x::Float128) = one(Float128) / x



function Base. +(x::Float128, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_add, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{D2}), x.d2, y.d2, r)
    Float128(r[])
end
function Base. +(x::Float64, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_add_d_dd, libqd), Cvoid, (Cdouble, Ref{D2}, Ref{D2}),
          x, y.d2, r)
    Float128(r[])
end
function Base. +(x::Float128, y::Float64)
    r = Ref{D2}()
    ccall((:c_dd_add_dd_d, libqd), Cvoid, (Ref{D2}, Cdouble, Ref{D2}),
          x.d2, y, r)
    Float128(r[])
end



function Base. -(x::Float128, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_sub, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{D2}), x.d2, y.d2, r)
    Float128(r[])
end
function Base. -(x::Float64, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_sub_d_dd, libqd), Cvoid, (Cdouble, Ref{D2}, Ref{D2}),
          x, y.d2, r)
    Float128(r[])
end
function Base. -(x::Float128, y::Float64)
    r = Ref{D2}()
    ccall((:c_dd_sub_dd_d, libqd), Cvoid, (Ref{D2}, Cdouble, Ref{D2}),
          x.d2, y, r)
    Float128(r[])
end



function Base. *(x::Float128, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_mul, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{D2}), x.d2, y.d2, r)
    Float128(r[])
end
function Base. *(x::Float64, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_mul_d_dd, libqd), Cvoid, (Cdouble, Ref{D2}, Ref{D2}),
          x, y.d2, r)
    Float128(r[])
end
function Base. *(x::Float128, y::Float64)
    r = Ref{D2}()
    ccall((:c_dd_mul_dd_d, libqd), Cvoid, (Ref{D2}, Cdouble, Ref{D2}),
          x.d2, y, r)
    Float128(r[])
end



function Base. /(x::Float128, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_div, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{D2}), x.d2, y.d2, r)
    Float128(r[])
end
function Base. /(x::Float64, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_div_d_dd, libqd), Cvoid, (Cdouble, Ref{D2}, Ref{D2}),
          x, y.d2, r)
    Float128(r[])
end
function Base. /(x::Float128, y::Float64)
    r = Ref{D2}()
    ccall((:c_dd_div_dd_d, libqd), Cvoid, (Ref{D2}, Cdouble, Ref{D2}),
          x.d2, y, r)
    Float128(r[])
end

Base. \(x::Float128, y::Float128) = y / x
Base. \(x::Float64, y::Float128) = y / x
Base. \(x::Float128, y::Float64) = y / x



function Base.cmp(x::Float128, y::Float128)
    r = Ref{Cint}()
    ccall((:c_dd_comp, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{Cint}),
          x.d2, y.d2, r)
    Int(r[])
end
function Base.cmp(x::Float64, y::Float128)
    r = Ref{Cint}()
    ccall((:c_dd_comp_d_dd, libqd), Cvoid, (Cdouble, Ref{D2}, Ref{Cint}),
          x, y.d2, r)
    Int(r[])
end
function Base.cmp(x::Float128, y::Float64)
    r = Ref{Cint}()
    ccall((:c_dd_comp_dd_d, libqd), Cvoid, (Ref{D2}, Cdouble, Ref{Cint}),
          x.d2, y, r)
    Int(r[])
end

Base. ==(x::Float128, y::Float128) = cmp(x, y) == 0
Base. ==(x::Float64, y::Float128) = cmp(x, y) == 0
Base. ==(x::Float128, y::Float64) = cmp(x, y) == 0

Base. !=(x::Float128, y::Float128) = cmp(x, y) != 0
Base. !=(x::Float64, y::Float128) = cmp(x, y) != 0
Base. !=(x::Float128, y::Float64) = cmp(x, y) != 0

Base. <(x::Float128, y::Float128) = cmp(x, y) < 0
Base. <(x::Float64, y::Float128) = cmp(x, y) < 0
Base. <(x::Float128, y::Float64) = cmp(x, y) < 0

Base. <=(x::Float128, y::Float128) = cmp(x, y) <= 0
Base. <=(x::Float64, y::Float128) = cmp(x, y) <= 0
Base. <=(x::Float128, y::Float64) = cmp(x, y) <= 0

Base. >(x::Float128, y::Float128) = cmp(x, y) > 0
Base. >(x::Float64, y::Float128) = cmp(x, y) > 0
Base. >(x::Float128, y::Float64) = cmp(x, y) > 0

Base. >=(x::Float128, y::Float128) = cmp(x, y) >= 0
Base. >=(x::Float64, y::Float128) = cmp(x, y) >= 0
Base. >=(x::Float128, y::Float64) = cmp(x, y) >= 0



function Base.ceil(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_ceil, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.floor(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_floor, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.round(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_nint, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.trunc(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_aint, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end



function Base. ^(x::Float128, i::Integer)
    r = Ref{D2}()
    ccall((:c_dd_npwr, libqd), Cvoid, (Ref{D2}, Cint, Ref{D2}), x.d2, i, r)
    Float128(r[])
end

function Base.literal_pow(x::Float128, ::Val{2})
    r = Ref{D2}()
    ccall((:c_dd_sqr, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.sqrt(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_sqrt, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

export nroot
function nroot(x::Float128, i::Integer)
    r = Ref{D2}()
    ccall((:c_dd_nroot, libqd), Cvoid, (Ref{D2}, Cint, Ref{D2}), x.d2, i, r)
    Float128(r[])
end

function Base.exp(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_exp, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

Base.exp10(x::Float128) = exp(c128_log10 * x)

Base.exp2(x::Float128) = exp(c128_log2 * x)

function Base.log(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_log, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.log10(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_log10, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

Base.log2(x::Float128) = c128_1_log2 * log(x)

function Base.sin(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_sin, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.cos(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_cos, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.tan(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_tan, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.asin(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_asin, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.acos(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_acos, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.atan(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_atan, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.atan(x::Float128, y::Float128)
    r = Ref{D2}()
    ccall((:c_dd_atan2, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{D2}),
          x.d2, y.d2, r)
    Float128(r[])
end

Base.hypot(x::Float128, y::Float128) = sqrt(x^2 + y^2)

function Base.sinh(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_sinh, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.cosh(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_cosh, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.tanh(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_tanh, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.asinh(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_asinh, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.acosh(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_acosh, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.atanh(x::Float128)
    r = Ref{D2}()
    ccall((:c_dd_atanh, libqd), Cvoid, (Ref{D2}, Ref{D2}), x.d2, r)
    Float128(r[])
end

function Base.sincos(x::Float128)
    r = Ref{D2}()
    s = Ref{D2}()
    ccall((:c_dd_sincos, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{D2}), x.d2, r, s)
    Float128(r[]), Float128(s[])
end

export sincosh
function sincosh(x::Float128)
    r = Ref{D2}()
    s = Ref{D2}()
    ccall((:c_dd_sincosh, libqd), Cvoid, (Ref{D2}, Ref{D2}, Ref{D2}),
          x.d2, r, s)
    Float128(r[]), Float128(s[])
end



# Constants

const c128_0 = Float128(0.0)
const c128_1 = Float128(1.0)
const c128_eps = Float128(2^-104)
const c128_e = exp(Float128(1.0))
const c128_log10 = log(Float128(10.0))
const c128_log2 = log(Float128(2.0))
const c128_1_log2 = inv(c128_log2)
