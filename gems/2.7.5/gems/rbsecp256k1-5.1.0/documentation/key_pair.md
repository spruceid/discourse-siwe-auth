[Index](index.md)

Secp256k1::KeyPair
==================

Secp256k1::KeyPair represents a public-private Secp256k1 key pair.

Initializers
------------

#### new(public_key, private_key)

Initializes a new key pair with `public_key` (type: [PublicKey](public_key.md)) and `private_key` (type: [PrivateKey](private_key.md)).

Instance Methods
----------------

#### public_key

Returns the [PublicKey](public_key.md) part of this key pair.

#### private_key

Returns the [PrivateKey](private_key.md) part of this key pair.

#### ==(other)

Returns `true` if the `other` has the same public and private key.
