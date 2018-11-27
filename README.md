# [QD](https://github.com/eschnett/QD.jl)

A Julia library wrapping David H. Bailey's [QD
package](http://crd-legacy.lbl.gov/~dhbailey/mpdist/), providing high
precision `Float128` and `Float256` arithmetic.

[![Build Status (Travis)](https://travis-ci.org/eschnett/QD.jl.svg?branch=master)](https://travis-ci.org/eschnett/QD.jl)
[![Build status (Appveyor)](https://ci.appveyor.com/api/projects/status/vudrlp22h332qur6/branch/master?svg=true)](https://ci.appveyor.com/project/eschnett/qd-jl/branch/master)
[![Coverage Status (Coveralls)](https://coveralls.io/repos/github/eschnett/QD.jl/badge.svg?branch=master)](https://coveralls.io/github/eschnett/QD.jl?branch=master)

(Note: The test coverage is actually much higher. Julia's coverage
calculator misses many source code lines that are actually executed.)



### Similar packages

[[DoubleFloats]](https://github.com/JuliaMath/DoubleFloats.jl) is a
very similar package, likely based on the same code lineage.
[DoubleFloats] is more flexible (you can e.g. combine two `Float32` to
get a `Float64`-lookalike, which might be quite useful on GPUs.
[DoubleFloats] doesn't seem to support a `Float256`-equivalent type.

[[AccurateArithmetic]](https://github.com/JuliaMath/AccurateArithmetic.jl)
is based on similar ideas, but provides an implementation as functions
and not as a type.

[[ErrorfreeArithmetic]](https://github.com/JeffreySarnoff/ErrorfreeArithmetic.jl)
is based on similar ideas, but provides an implementation as functions
and not as a type.



## Example

This package provides two new types `Float128` and `Float256` that
have a much higher precision than `Float64` -- they have about 30 and
60 digits of precision, respectively.

Let's test this by evaluating the fraction `1/3` with various
precisions:

```Julia
julia> big(1/3)
3.33333333333333314829616256247390992939472198486328125e-01
```
`Float64` has 16 correct digits.

```Julia
julia> big(one(Float128)/3)
3.333333333333333333333333333333323061706963268075450368117639547054301130124543e-01
```
`Float128` has 32 correct digits.

```Julia
julia> big(one(Float256)/3)
3.333333333333333333333333333333333333333333333333333333333333333301681440847467e-01
```
`Float256` has 65 correct digits.

We can also evaluate the constant `π` and compare to `BigFloat`:

```Julia
julia> big(Float64(π))
3.141592653589793115997963468544185161590576171875
julia> round(big(Float64(π)) - big(π), sigdigits=3)
-1.22e-16

julia> big(Float128(π))
3.141592653589793238462643383279505878966979117714660462569212467758006379625613
julia> round(big(Float128(π)) - big(π), sigdigits=3)
2.99e-33

julia> big(Float256(π))
3.141592653589793238462643383279502884197169399375105820974944592302144174306569
julia> round(big(Float256(π)) - big(π), sigdigits=3)
-5.67e-66

julia> big(π)
3.141592653589793238462643383279502884197169399375105820974944592307816406286198
```

There is not much else to say. If your code is type-generic (and this
is Julia, it really should be!), then you can use `Float128` and
`Float256` as drop-in replacement for `Float64` or `BigFloat`. All
basic arithmetic (`+` `-` `*` `/` `^`) and most elementary function
(`sqrt`, `sin`, `cos`, ...) are supported.

## Speed and memory usage

The main advantage of `Float128` and `Float256` over `BigFloat` is
their speed and their compact representation which doesn't require
memory allocations:

```Julia
julia> using BenchmarkTools
julia> using LinearAlgebra
julia> n=100;

julia> A64 = rand(Float64, n, n);
julia> B64 = @btime inv(A64);
  306.157 μs (6 allocations: 129.27 KiB)
julia> norm(B64 * A64 - I)
1.4440108319436736e-12

julia> A128 = rand(Float128, n, n);
julia> B128 = @btime inv(A128);
  5.177 ms (15 allocations: 474.42 KiB)
julia> norm(B128 * A128 - I)
1.19496652320293845810089276691420e-28

julia> A256 = rand(Float256, n, n);
julia> B256 = @btime inv(A256);
  95.517 ms (15 allocations: 946.14 KiB)
julia> norm(B256 * A256 - I)
3.4293792195278235762102730788487570191920941211322204339008314344e-61

julia> Abig = rand(BigFloat, n, n);
julia> Bbig = @btime inv(Abig);
  271.446 ms (5334037 allocations: 285.10 MiB)
julia> norm(Bbig * Abig - I)
1.187140215116236991926392678171305368288858808728624740197177252518979524096639e-73
```

(Times measured on a 2.8 GHz Intel Core i7.) This benchmarks inverts a
`100 × 100` matrix. `Float128` is here about 50 times faster than
`BigFloat` (but less than half as accurate), and `Float256` is about
twice as fast and requires no memory allocations.
