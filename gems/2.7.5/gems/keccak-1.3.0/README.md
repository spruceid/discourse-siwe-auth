# The Keccak (SHA3) digest for Ruby

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/q9f/keccak.rb/Build/main)](https://github.com/q9f/keccak.rb/actions)
[![GitHub top language](https://img.shields.io/github/languages/top/q9f/keccak.rb?color=black)](https://github.com/q9f/keccak.rb/pulse)
[![GitHub release](https://img.shields.io/github/v/release/q9f/keccak.rb?color=red)](https://github.com/q9f/keccak.rb/releases/latest)
[![Gem](https://img.shields.io/gem/v/keccak?color=red)](https://rubygems.org/gems/keccak)
[![License](https://img.shields.io/github/license/q9f/keccak.rb.svg?color=black)](LICENSE)

This Ruby extension exposes the [Keccak](http://keccak.noekeon.org/) (SHA3) digest `C` bindings in the non-final version used by [Ethereum](https://ethereum.org). It is based on the reference `C` implementation, version 3.2. The exposed interface is almost identical to that of the `digest` standard library. See [#16](https://github.com/q9f/keccak.rb/pull/16).

:warning: **Note: version `~> 1.3` exposes `digest/keccak` (`Digest::Keccak`) whereas version `~> 1.2` maintains the old `digest/sha3` (`Digest::SHA3`) for backward compatibility.** Only use `~> 1.2` if you want to lazy-patch your library. It works, but it's _not recommended._ Use `~> 1.3` and simply rename SHA3 to Keccak.

## Installation

The gem is called `keccak`.

```bash
bundle add keccak
gem install keccak
```

```ruby
gem 'keccak', '~> 1.3'
```

**Note**: as of version `~> v1.1`, `digest-sha3` (historic name, see below) requires Ruby 2.2. The new `keccak` version `~> v1.2` now also supports Ruby 3.0. The last version that worked on older Ruby (1.x) versions was `~> v1.0`. It can be found at the no longer maintained `digest-sha3` [repository from 2015](https://github.com/phusion/digest-sha3-ruby/releases/tag/release-1.0.2).

## Usage

This gem extends the `digest/*` module by a `digest/keccak` class.

```ruby
require 'digest/keccak'

# Generate 512-bit digest.
Digest::Keccak.digest("foo")       # => "\025\227\204*..."
Digest::Keccak.hexdigest("foo")    # => "1597842a..."

# Generate 224-bit digest.
Digest::Keccak.digest("foo", 224)       # => "\332\251M\247..."
Digest::Keccak.hexdigest("foo", 224)    # => "daa94da7..."

# Use this interface to feed data in chunks. 512-bit by default.
digest = Digest::Keccak.new
digest.update("f")
digest.update("o")
digest.update("o")
digest.digest       # => "\025\227\204*..."
digest.hexdigest    # => "1597842a..."

# You can pass a hash length to the constructor.
digest = Digest::Keccak.new(224)
```

Keccak supports five hash lengths: 224-bit, 256-bit, 384-bit, 512-bit and variable length. Variable length is not supported by this Ruby extension. Unless the user specifies otherwise, this Ruby extension assumes 512-bit.

## Running the test suite

Run the test suite as follows:

```bash
bundle install
make test
```

A part of the test suite is automatically generated from Keccak's reference test suite.

## Warning: Keccak vs. SHA3

**Note:** This gem still uses the `Digest::SHA3` namespace in version `~> 1.2` for reasons of backward compatibility and long-term maintainability. See history section below.

:warning: This gem does **not** implement the final FIPS202 standard, today known as SHA3 but rather an early version, commonly referred to as Keccak. The reason why this is kept around, is that Ethereum uses this earler version of Keccak. See also: [Ethereum: Difference between keccak256 and sha3](https://ethereum.stackexchange.com/questions/30369/difference-between-keccak256-and-sha3).

If you are looking for the final SHA3 gem, please use the following: https://rubygems.org/gems/sha3

## History

This gem was initially developed and published as `digest-sha3`: https://github.com/phusion/digest-sha3-ruby

This gem was later patched multiple times:

* https://github.com/teamhedge/digest-sha3-ruby (KECCAK, as `digest-sha3-patched`)
* https://github.com/sydneyitguy/digest-sha3-ruby (KECCAK, as `digest-sha3-patched-ruby-3`)
* https://github.com/steakknife/digest-sha3-ruby (actual SHA3, do not use for Ethereum)
* https://github.com/kotovalexarian/digest-keccak/ (KECCAK, as `digest-keccak`)
