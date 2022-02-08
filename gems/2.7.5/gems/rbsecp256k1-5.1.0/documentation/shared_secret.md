[Index](index.md)

Secp256k1::SharedSecret
=======================

**Requires:** libsecp256k1 was build with ECDH module.

Secp256k1::SharedSecret represents a 32-byte shared secret computed from a
public key (point) and private key (scalar).

Instance Methods
----------------

#### data

Binary string containing the 32-byte shared secret.
