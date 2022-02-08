[Index](index.md)

Secp256k1::PublicKey
====================

Secp256k1::PublicKey represents the public key part of a public-private key pair.

See: [KeyPair](key_pair.md)

Class Methods
-------------

#### from_data(public_key_data)

Parses compressed or uncompressed from binary string `public_key_data` and
creates and returns a new public key from it. Raises a `Secp256k1::DeserializationError`
if the given public key data is invalid.

Instance Methods
----------------

#### compressed

Returns the binary compressed representation of this public key.

#### uncompressed

Returns the binary uncompressed representation of this public key.

#### ==(other)

Return `true` if this public key matches `other`.
