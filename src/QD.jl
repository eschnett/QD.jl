module QD

using Libdl
const libqd = "/Users/eschnett/qd-2.3.22/lib/libqd.0.dylib"
Libdl.dlopen(libqd)



# Types

const DD = NTuple{2, Cdouble} 

export Float128
struct Float128 <: AbstractFloat
    dd::DD
end



# Functions

function Base.show(io::IO, x::Float128)
    len = 40
    buf = Vector{Cchar}(undef, len)
    prec = 32
    ccall((:c_dd_swrite, libqd), Cvoid, (Ref{DD}, Cint, Ptr{Cchar}, Cint),
          x.dd, prec, buf, len)
    print(io, unsafe_string(pointer(buf)))
end



function Float128(x::Float64)
    r = Ref{DD}()
    ccall((:c_dd_copy_d, libqd), Cvoid, (Cdouble, Ref{DD}), x, r)
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
    x1 = x - BigFloat(r1)
    r2 = r1 + Float128(Float64(x1))
    r2
end

Base.Float64(x::Float128) = x.dd[1]
Base.BigFloat(x::Float128) = big(x.dd[1]) + big(x.dd[2])

Base.big(::Type{Float128}) = BigFloat

Base.promote_rule(::Type{Float128}, ::Type{Float16}) = Float128
Base.promote_rule(::Type{Float128}, ::Type{Float32}) = Float128
Base.promote_rule(::Type{Float128}, ::Type{Float64}) = Float128
Base.promote_rule(::Type{Float128}, ::Type{BigFloat}) = BigFloat
Base.promote_rule(::Type{Float128}, ::Type{I}) where {I <: Integer} = Float128
Base.promote_rule(::Type{Float128}, ::Type{BigInt}) = BigFloat



function Float128(::Irrational{:π})
    r = Ref{DD}()
    ccall((:c_dd_pi, libqd), Cvoid, (Ref{DD},), r)
    Float128(r[])
end
Float128(::Irrational{:ℯ}) = c_e
Base.zero(::Type{Float128}) = c_0
Base.one(::Type{Float128}) = c_1
Base.eps(::Type{Float128}) = c_eps



Base. +(x::Float128) = x

function Base. -(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_neg, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.abs(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_abs, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

Base.inv(x::Float128) = one(Float128) / x



function Base. +(x::Float128, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_add, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{DD}), x.dd, y.dd, r)
    Float128(r[])
end
function Base. +(x::Float64, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_add_d_dd, libqd), Cvoid, (Cdouble, Ref{DD}, Ref{DD}),
          x, y.dd, r)
    Float128(r[])
end
function Base. +(x::Float128, y::Float64)
    r = Ref{DD}()
    ccall((:c_dd_add_dd_d, libqd), Cvoid, (Ref{DD}, Cdouble, Ref{DD}),
          x.dd, y, r)
    Float128(r[])
end



function Base. -(x::Float128, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_sub, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{DD}), x.dd, y.dd, r)
    Float128(r[])
end
function Base. -(x::Float64, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_sub_d_dd, libqd), Cvoid, (Cdouble, Ref{DD}, Ref{DD}),
          x, y.dd, r)
    Float128(r[])
end
function Base. -(x::Float128, y::Float64)
    r = Ref{DD}()
    ccall((:c_dd_sub_dd_d, libqd), Cvoid, (Ref{DD}, Cdouble, Ref{DD}),
          x.dd, y, r)
    Float128(r[])
end



function Base. *(x::Float128, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_mul, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{DD}), x.dd, y.dd, r)
    Float128(r[])
end
function Base. *(x::Float64, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_mul_d_dd, libqd), Cvoid, (Cdouble, Ref{DD}, Ref{DD}),
          x, y.dd, r)
    Float128(r[])
end
function Base. *(x::Float128, y::Float64)
    r = Ref{DD}()
    ccall((:c_dd_mul_dd_d, libqd), Cvoid, (Ref{DD}, Cdouble, Ref{DD}),
          x.dd, y, r)
    Float128(r[])
end



function Base. /(x::Float128, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_div, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{DD}), x.dd, y.dd, r)
    Float128(r[])
end
function Base. /(x::Float64, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_div_d_dd, libqd), Cvoid, (Cdouble, Ref{DD}, Ref{DD}),
          x, y.dd, r)
    Float128(r[])
end
function Base. /(x::Float128, y::Float64)
    r = Ref{DD}()
    ccall((:c_dd_div_dd_d, libqd), Cvoid, (Ref{DD}, Cdouble, Ref{DD}),
          x.dd, y, r)
    Float128(r[])
end

Base. \(x::Float128, y::Float128) = y / x
Base. \(x::Float64, y::Float128) = y / x
Base. \(x::Float128, y::Float64) = y / x



function Base.cmp(x::Float128, y::Float128)
    r = Ref{Cint}()
    ccall((:c_dd_comp, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{Cint}),
          x.dd, y.dd, r)
    Int(r)
end
function Base.cmp(x::Float64, y::Float128)
    r = Ref{Cint}()
    ccall((:c_dd_comp_d_dd, libqd), Cvoid, (Cdouble, Ref{DD}, Ref{Cint}),
          x, y.dd, r)
    Int(r)
end
function Base.cmp(x::Float128, y::Float64)
    r = Ref{Cint}()
    ccall((:c_dd_comp_dd_d, libqd), Cvoid, (Ref{DD}, Cdouble, Ref{Cint}),
          x.dd, y, r)
    Int(r)
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
    r = Ref{DD}()
    ccall((:c_dd_ceil, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.floor(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_floor, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.round(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_nint, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.trunc(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_aint, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end



function Base. ^(x::Float128, i::Integer)
    r = Ref{DD}()
    ccall((:c_dd_npwr, libqd), Cvoid, (Ref{DD}, Cint, Ref{DD}), x.dd, i, r)
    Float128(r[])
end

function Base.literal_pow(x::Float128, ::Val{2})
    r = Ref{DD}()
    ccall((:c_dd_sqr, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.sqrt(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_sqrt, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

export nroot
function nroot(x::Float128, i::Integer)
    r = Ref{DD}()
    ccall((:c_dd_nroot, libqd), Cvoid, (Ref{DD}, Cint, Ref{DD}), x.dd, i, r)
    Float128(r[])
end

function Base.exp(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_exp, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

Base.exp10(x::Float128) = exp(c_log10 * x)

Base.exp2(x::Float128) = exp(c_log2 * x)

function Base.log(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_log, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.log10(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_log10, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

Base.log2(x::Float128) = c_1_log2 * log(x)

function Base.sin(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_sin, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.cos(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_cos, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.tan(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_tan, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.asin(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_asin, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.acos(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_acos, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.atan(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_atan, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.atan(x::Float128, y::Float128)
    r = Ref{DD}()
    ccall((:c_dd_atan2, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{DD}),
          x.dd, y.dd, r)
    Float128(r[])
end

Base.hypot(x::Float128, y::Float128) = sqrt(x^2 + y^2)

function Base.sinh(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_sinh, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.cosh(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_cosh, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.tanh(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_tanh, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.asinh(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_asinh, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.acosh(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_acosh, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.atanh(x::Float128)
    r = Ref{DD}()
    ccall((:c_dd_atanh, libqd), Cvoid, (Ref{DD}, Ref{DD}), x.dd, r)
    Float128(r[])
end

function Base.sincos(x::Float128)
    r = Ref{DD}()
    s = Ref{DD}()
    ccall((:c_dd_sincos, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{DD}), x.dd, r, s)
    Float128(r[]), Float128(s[])
end

export sincosh
function sincosh(x::Float128)
    r = Ref{DD}()
    s = Ref{DD}()
    ccall((:c_dd_sincosh, libqd), Cvoid, (Ref{DD}, Ref{DD}, Ref{DD}),
          x.dd, r, s)
    Float128(r[]), Float128(s[])
end



# Constants

const c_0 = Float128(0.0)
const c_1 = Float128(1.0)
const c_eps = Float128(2^-104)
const c_e = exp(Float128(1.0))
const c_log10 = log(Float128(10.0))
const c_log2 = log(Float128(2.0))
const c_1_log2 = inv(c_log2)

end
