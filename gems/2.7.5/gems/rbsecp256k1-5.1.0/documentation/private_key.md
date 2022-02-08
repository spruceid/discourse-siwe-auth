[Index](index.md)

Secp256k1::PrivateKey
=====================

Secp256k1::PrivateKey represents the private key part of a public-private key pair.

Class Methods
-------------

#### from_data(private_key_data)

Loads new private key from the given binary `private_key_data` string. Raises
`Secp256k1::Error` if the given data is invalid.

Instance Methods
----------------

#### data

Returns the binary private key data as a `String`.

#### ==(other)

Returns `true` if this private key matches `other`.
