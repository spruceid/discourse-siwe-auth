# rbsecp256k1

[![Spec](https://github.com/etscrivner/rbsecp256k1/actions/workflows/spec.yml/badge.svg?branch=master)](https://github.com/etscrivner/rbsecp256k1/actions/workflows/spec.yml) [![Gem Version](https://badge.fury.io/rb/rbsecp256k1.svg)](https://badge.fury.io/rb/rbsecp256k1) [![Maintainability](https://api.codeclimate.com/v1/badges/d4b6e27bfa00030ca412/maintainability)](https://codeclimate.com/github/etscrivner/rbsecp256k1/maintainability)

Native extension gem for secp256k1 ECDSA. Wraps [libsecp256k1](https://github.com/bitcoin-core/secp256k1). In
rbsecp256k1 3.0.0 and later libsecp256k1 is bundled with the gem.

* [Documentation](https://github.com/etscrivner/rbsecp256k1/blob/master/documentation/index.md)
* [Examples](https://github.com/etscrivner/rbsecp256k1/blob/master/examples/README.md)

### Why wrap libsecp256k1?

[libsecp256k1](https://github.com/bitcoin-core/secp256k1) is an extremely optimized implementation of public key derivation,
signing, and verification with the secp256k1 elliptic curve. It comes with its
own set of benchmarks, but from [benchmarking done by Peter Wuille](https://www.reddit.com/r/Bitcoin/comments/2weymr/experiment_bitcoin_core_0100_initial_sync_time/coqghm2) it is ~4.9x
faster than the OpenSSL implementation of the same curve. It is the only library
that provides constant time signing of this curve and has been deployed as part
of Bitcoin since [v0.10.0](https://bitcoin.org/en/release/v0.10.0#improved-signing-security)

Natively wrapping the library in an extension gem means users don't have to
worry about compiling or locating the library, unlike many [FFI](https://github.com/ffi/ffi) based gems.

## Installation

The simplest installation:

```
gem install rbsecp256k1
```

## Requirements

If you want to use your system version of libsecp256k1 rather than the bundled
version use the `--with-system-libraries` flag:

```
gem install rbsecp256k1 -- --with-system-libraries
```

#### Linux

Install the dependencies for building libsecp256k1 and this library:

```
sudo apt-get install build-essential automake pkg-config libtool \
  libffi-dev libssl-dev libgmp-dev python-dev
```

**NOTE:** If you have installed libsecp256k1 but the gem cannot find it. Ensure
you have run `ldconfig` so that your library load paths have been updated.

#### macOS

Dependencies for building libsecp256k1 and this library:

```
brew install openssl libtool pkg-config gmp libffi
```

## Features

See [rbsecp256k1 documentation](https://github.com/etscrivner/rbsecp256k1/blob/master/documentation/index.md) for examples and complete list of supported functionality.

## Development

### Cloning

To clone the repository and its submodules you'll need to the following:

```
git clone git@github.com:etscrivner/rbsecp256k1.git
```

### Setup

Development is largely facilitated by a makefile. After download you should run
the following command to set up your local environment:

```
make setup
```

### Compiling Extension

To compile the extension gem run the following (this is required to run tests):

```
make build
```

### Running Tests

```
make test
```

To test with recovery functionality disabled run:

```
make test WITH_RECOVERY=0
```

To test with ECDH functionality disabled run:

```
make test WITH_ECDH=0
```

To test with both disabled run:

```
make test WITH_RECOVERY=0 WITH_ECDH=0
```

Testing for memory leaks with valgrind:

```
make memcheck
```

### Building Gem

```
make gem
```

### Installing Gem Locally

To install the gem locally and verify builds you can run:

```
make install
```

### Uninstall Gem Locally

You can similarly uninstall the local gem by running the following:

```
make uninstall
```

### Cleaning Up

To clean up and do a fresh build:

```
make clean
```

### Running YARD Documentation Server

To run the [YARD](https://yardoc.org/) documentation server:

```
make docserver
```
