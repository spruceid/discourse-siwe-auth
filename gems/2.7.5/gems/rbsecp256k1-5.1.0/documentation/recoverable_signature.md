[Index](index.md)

Secp256k1::RecoverableSignature
===============================

**Requires:** libsecp256k1 was build with recovery module.

Secp256k1::RecoverableSignature represents a recoverable ECDSA signature
signing the 32-byte SHA-256 hash of some data.

Instance Methods
----------------

#### compact

Returns an array whose first element is the 64-byte compact signature as a
binary string and whose second element is the integer recovery ID.

#### recover_public_key

Recovers the public key corresponding to the recoverable signature. Returns a
[PublicKey](public_key.md).

#### to_signature

Converts a recoverable signature to a non-recoverable [Signature](signature.md) object.

#### ==(other)

Returns `true` if this recoverable signature matches `other`.
