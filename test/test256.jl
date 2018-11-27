@test isequal(Float64(Float256(42.0)), 42.0)
@test isequal(Float64(Float256(42.0f0)), 42.0)
@test isequal(Float64(Float256(42)), 42.0)
@test isequal(Float64(Float256(0x2a)), 42.0)

@test isequal(Float128(Float256(42.0)), Float128(42.0))
@test isequal(Float128(Float256(42.0f0)), Float128(42.0))
@test isequal(Float128(Float256(42)), Float128(42.0))
@test isequal(Float128(Float256(0x2a)), Float128(42.0))

@test Float64(eps(Float256)) <= 1.0e-60

@test isequal(big(zero(Float256)), big(0))
@test isequal(big(one(Float256)), big(1))
@test abs(big(Float256(π)) - big(π)) <= eps(Float256)
@test abs(big(Float256(ℯ)) - big(ℯ)) <= eps(Float256)



pi256 = f256"3.141592653589793238462643383279502884197169399375105820974944592307816406286198"
@test isequal(big(pi256), Float256(π))
@test isequal(parse(Float256, string(pi256)), pi256)



for n in 1:1000
    x64 = rand(Float64)
    y64 = rand(Float64)

    @test isequal(Float64(Float256(x64)), x64)

    x128 = Float128(rand(BigFloat))
    y128 = Float128(rand(BigFloat))

    @test isequal(Float128(Float256(x128)), x128)

    xbig = rand(BigFloat)
    @test isequal(big(Float256(x64)), big(x64))
    @test isequal(big(Float256(x128)), big(x128))
    @test abs(big(Float256(xbig)) - xbig) <= eps(Float256)

    x = Float256(rand(BigFloat))
    y = Float256(rand(BigFloat))

    @test isequal(big(+ x), + big(x))
    @test isequal(big(- x), - big(x))
    @test isequal(big(abs(x)), abs(big(x)))
    @test approxeq(Float256, 2, [x], big(inv(x)),  inv(big(x)))

    @test abs(big(x + y) - (big(x) + big(y))) <= eps(Float256)
    @test abs(big(x128 + y) - (big(x128) + big(y))) <= eps(Float256)
    @test abs(big(x64 + y) - (big(x64) + big(y))) <= eps(Float256)
    @test abs(big(x + y128) - (big(x) + big(y128))) <= eps(Float256)
    @test abs(big(x + y64) - (big(x) + big(y64))) <= eps(Float256)

    @test abs(big(x - y) - (big(x) - big(y))) <= eps(Float256)
    @test abs(big(x128 - y) - (big(x128) - big(y))) <= eps(Float256)
    @test abs(big(x64 - y) - (big(x64) - big(y))) <= eps(Float256)
    @test abs(big(x - y128) - (big(x) - big(y128))) <= eps(Float256)
    @test abs(big(x - y64) - (big(x) - big(y64))) <= eps(Float256)

    @test abs(big(x * y) - (big(x) * big(y))) <= eps(Float256)
    @test abs(big(x128 * y) - (big(x128) * big(y))) <= eps(Float256)
    @test abs(big(x64 * y) - (big(x64) * big(y))) <= eps(Float256)
    @test abs(big(x * y128) - (big(x) * big(y128))) <= eps(Float256)
    @test abs(big(x * y64) - (big(x) * big(y64))) <= eps(Float256)

    @test approxeq(Float256, 2, [x, y], big(x / y), big(x) / big(y))
    @test approxeq(Float256, 2, [x, y], big(x128 / y), big(x128) / big(y))
    @test approxeq(Float256, 2, [x, y], big(x64 / y), big(x64) / big(y))
    @test approxeq(Float256, 2, [x, y], big(x / y128), big(x) / big(y128))
    @test approxeq(Float256, 2, [x, y], big(x / y64), big(x) / big(y64))

    @test approxeq(Float256, 2, [x, y], big(x \ y), big(x) \ big(y))
    @test approxeq(Float256, 2, [x, y], big(x128 \ y), big(x128) \ big(y))
    @test approxeq(Float256, 2, [x, y], big(x64 \ y), big(x64) \ big(y))
    @test approxeq(Float256, 2, [x, y], big(x \ y128), big(x) \ big(y128))
    @test approxeq(Float256, 2, [x, y], big(x \ y64), big(x) \ big(y64))

    @test isequal(x == x, big(x) == big(x))
    @test isequal(x != x, big(x) != big(x))
    @test isequal(x < x, big(x) < big(x))
    @test isequal(x <= x, big(x) <= big(x))
    @test isequal(x > x, big(x) > big(x))
    @test isequal(x >= x, big(x) >= big(x))

    @test isequal(x == y, big(x) == big(y))
    @test isequal(x != y, big(x) != big(y))
    @test isequal(x < y, big(x) < big(y))
    @test isequal(x <= y, big(x) <= big(y))
    @test isequal(x > y, big(x) > big(y))
    @test isequal(x >= y, big(x) >= big(y))

    @test isequal(x64 == y, big(x64) == big(y))
    @test isequal(x64 != y, big(x64) != big(y))
    @test isequal(x64 < y, big(x64) < big(y))
    @test isequal(x64 <= y, big(x64) <= big(y))
    @test isequal(x64 > y, big(x64) > big(y))
    @test isequal(x64 >= y, big(x64) >= big(y))

    @test isequal(x == y64, big(x) == big(y64))
    @test isequal(x != y64, big(x) != big(y64))
    @test isequal(x < y64, big(x) < big(y64))
    @test isequal(x <= y64, big(x) <= big(y64))
    @test isequal(x > y64, big(x) > big(y64))
    @test isequal(x >= y64, big(x) >= big(y64))

    @test isequal(big(floor(1.0e10 * x)), floor(big(1.0e10 * x)))
    @test isequal(big(ceil(1.0e10 * x)), ceil(big(1.0e10 * x)))
    @test isequal(big(round(1.0e10 * x)), round(big(1.0e10 * x)))
    @test isequal(big(trunc(1.0e10 * x)), trunc(big(1.0e10 * x)))

    @test abs(big(x ^ 2) - big(x) ^ 2) <= eps(Float256)
    @test approxeq(Float256, 10, [x], big(x ^ 5), big(x) ^ 5)
    @test approxeq(Float256, 2, [abs(x)],
                   big(sqrt(abs(x))), sqrt(big(abs(x))))
    @test approxeq(Float256, 10, [abs(x)],
                   big(nroot(abs(x), 5)), big(abs(x)) ^ (big(1)/5))

    @test approxeq(Float256, 10, [x], big(exp(x)), exp(big(x)))
    @test approxeq(Float256, 10, [x], big(exp10(x)), exp10(big(x)))
    @test approxeq(Float256, 10, [x], big(exp2(x)), exp2(big(x)))
    @test approxeq(Float256, 10,
                   [abs(x)], big(log(abs(x))), log(big(abs(x))))
    @test approxeq(Float256, 10,
                   [abs(x)], big(log10(abs(x))), log10(big(abs(x))))
    @test approxeq(Float256, 10,
                   [abs(x)], big(log2(abs(x))), log2(big(abs(x))))

    @test approxeq(Float256, 10, [x], big(sin(x)), sin(big(x)))
    @test approxeq(Float256, 10, [x], big(cos(x)), cos(big(x)))
    @test approxeq(Float256, 10, [x], big(tan(x)), tan(big(x)))
    @test approxeq(Float256, 10, [x], big(sincos(x)[1]), sin(big(x)))
    @test approxeq(Float256, 10, [x], big(sincos(x)[2]), cos(big(x)))

    @test approxeq(Float256, 10, [x], big(asin(x)), asin(big(x)))
    @test approxeq(Float256, 100, [x], big(acos(x)), acos(big(x)))
    @test approxeq(Float256, 10, [x], big(atan(x)), atan(big(x)))
    @test approxeq(Float256, 10, [x, y],
                   big(atan(x, y)), atan(big(x), big(y)))
    @test approxeq(Float256, 10, [x, y],
                   big(hypot(x, y)), hypot(big(x), big(y)))

    @test approxeq(Float256, 10, [x], big(sinh(x)), sinh(big(x)))
    @test approxeq(Float256, 10, [x], big(cosh(x)), cosh(big(x)))
    @test approxeq(Float256, 10, [x], big(tanh(x)), tanh(big(x)))
    @test approxeq(Float256, 10, [x], big(sincosh(x)[1]), sinh(big(x)))
    @test approxeq(Float256, 10, [x], big(sincosh(x)[2]), cosh(big(x)))

    @test approxeq(Float256, 10, [x], big(asinh(x)), asinh(big(x)))
    @test approxeq(Float256, 10, [x + 2], big(acosh(x + 2)), acosh(big(x + 2)))
    @test approxeq(Float256, 10, [x], big(atanh(x)), atanh(big(x)))
end



n = 100
A256 = rand(Float256, n, n)
B256 = inv(A256)
@test norm(B256 * A256 - I) <= n * norm(A256) * norm(B256) * eps(Float256)

Abig = rand(BigFloat, n, n);
Bbig = inv(Abig);
@test norm(Bbig * Abig - I) <= n * norm(Abig) * norm(Bbig) * eps(BigFloat)
