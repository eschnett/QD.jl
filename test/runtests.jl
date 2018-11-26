using Test
using QD



x64 = rand(Float64)
y64 = rand(Float64)

@test isequal(Float64(Float128(x64)), x64)
@test isequal(Float64(Float128(42.0)), 42.0)
@test isequal(Float64(Float128(42.0f0)), 42.0)
@test isequal(Float64(Float128(42)), 42.0)
@test isequal(Float64(Float128(0x2a)), 42.0)

@test Float64(eps(Float128)) <= 1.0e-30

xbig = rand(BigFloat)
@test isequal(big(Float128(x64)), big(x64))
@test abs(big(Float128(xbig)) - xbig) <= eps(Float128)

x = Float128(rand(BigFloat))
y = Float128(rand(BigFloat))

@test abs(big(Float128(π)) - big(π)) <= eps(Float128)
@test abs(big(Float128(ℯ)) - big(ℯ)) <= eps(Float128)

@test isequal(big(+ x), + big(x))
@test isequal(big(- x), - big(x))
@test isequal(big(abs(x)), abs(big(x)))
@test abs(big(inv(x)) - inv(big(x))) <= 2*eps(Float128)

@test abs(big(x + y) - (big(x) + big(y))) <= eps(Float128)
@test abs(big(x64 + y) - (big(x64) + big(y))) <= eps(Float128)
@test abs(big(x + y64) - (big(x) + big(y64))) <= eps(Float128)

@test abs(big(x - y) - (big(x) - big(y))) <= eps(Float128)
@test abs(big(x64 - y) - (big(x64) - big(y))) <= eps(Float128)
@test abs(big(x - y64) - (big(x) - big(y64))) <= eps(Float128)

@test abs(big(x * y) - (big(x) * big(y))) <= eps(Float128)
@test abs(big(x64 * y) - (big(x64) * big(y))) <= eps(Float128)
@test abs(big(x * y64) - (big(x) * big(y64))) <= eps(Float128)

@test abs(big(x / y) - (big(x) / big(y))) <= eps(Float128)
@test abs(big(x64 / y) - (big(x64) / big(y))) <= eps(Float128)
@test abs(big(x / y64) - (big(x) / big(y64))) <= 10 * eps(Float128)

@test abs(big(x \ y) - (big(x) \ big(y))) <= eps(Float128)
@test abs(big(x64 \ y) - (big(x64) \ big(y))) <= 10 * eps(Float128)
@test abs(big(x \ y64) - (big(x) \ big(y64))) <= eps(Float128)

@test isequal(big(floor(1.0e10 * x)), floor(big(1.0e10 * x)))
@test isequal(big(ceil(1.0e10 * x)), ceil(big(1.0e10 * x)))
@test isequal(big(round(1.0e10 * x)), round(big(1.0e10 * x)))
@test isequal(big(trunc(1.0e10 * x)), trunc(big(1.0e10 * x)))

@test abs(big(x ^ 2) - big(x) ^ 2) <= eps(Float128)
@test abs(big(x ^ 5) - big(x) ^ 5) <= eps(Float128)
@test abs(big(sqrt(abs(x))) - sqrt(big(abs(x)))) <= eps(Float128)
@test abs(big(nroot(abs(x), 5)) - big(abs(x)) ^ (big(1)/5)) <= 100*eps(Float128)

@test abs(big(exp(x)) - exp(big(x))) <= 10*eps(Float128)
@test abs(big(exp10(x)) - exp10(big(x))) <= 10*eps(Float128)
@test abs(big(exp2(x)) - exp2(big(x))) <= 10*eps(Float128)
@test abs(big(log(abs(x))) - log(big(abs(x)))) <= eps(Float128)
@test abs(big(log10(abs(x))) - log10(big(abs(x)))) <= eps(Float128)
@test abs(big(log2(abs(x))) - log2(big(abs(x)))) <= 10*eps(Float128)

@test abs(big(sin(x)) - sin(big(x))) <= eps(Float128)
@test abs(big(cos(x)) - cos(big(x))) <= eps(Float128)
@test abs(big(tan(x)) - tan(big(x))) <= eps(Float128)
@test abs(big(sincos(x)[1]) - sin(big(x))) <= eps(Float128)
@test abs(big(sincos(x)[2]) - cos(big(x))) <= eps(Float128)

@test abs(big(asin(x)) - asin(big(x))) <= eps(Float128)
@test abs(big(acos(x)) - acos(big(x))) <= eps(Float128)
@test abs(big(atan(x)) - atan(big(x))) <= 10*eps(Float128)
@test abs(big(atan(x, y)) - atan(big(x), big(y))) <= eps(Float128)
@test abs(big(hypot(x, y)) - hypot(big(x), big(y))) <= eps(Float128)

@test abs(big(sinh(x)) - sinh(big(x))) <= eps(Float128)
@test abs(big(cosh(x)) - cosh(big(x))) <= eps(Float128)
@test abs(big(tanh(x)) - tanh(big(x))) <= eps(Float128)
@test abs(big(sincosh(x)[1]) - sinh(big(x))) <= eps(Float128)
@test abs(big(sincosh(x)[2]) - cosh(big(x))) <= eps(Float128)

@test abs(big(asinh(x)) - asinh(big(x))) <= eps(Float128)
@test abs(big(acosh(x + 2)) - acosh(big(x + 2))) <= eps(Float128)
@test abs(big(atanh(x)) - atanh(big(x))) <= eps(Float128)
