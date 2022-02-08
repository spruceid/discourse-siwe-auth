#include "ruby.h"
#ifdef HAVE_RUBY_DIGEST_H
#include "ruby/digest.h"
#else
#include "digest.h"
#endif
#include "KeccakNISTInterface.h"

#define MAX_DIGEST_SIZE 64
#define DEFAULT_DIGEST_LEN 512

static int keccak_init_func();
static void keccak_update_func(hashState *ctx, unsigned char *str, size_t len);
static int keccak_finish_func(hashState *ctx, unsigned char *digest);

/*
  Metadata definition for the Keccak algorithm.
  Defines the Version, sizes for block and digest as well as
  the entry points for the algorithms
*/
static rb_digest_metadata_t keccak = {
	RUBY_DIGEST_API_VERSION,
	DEFAULT_DIGEST_LEN,
	KeccakPermutationSize - (2 * DEFAULT_DIGEST_LEN), //size of blocks
	sizeof(hashState), //size of context for the object we'll be passed in below functions.
	(rb_digest_hash_init_func_t)keccak_init_func,
	(rb_digest_hash_update_func_t)keccak_update_func,
	(rb_digest_hash_finish_func_t)keccak_finish_func,
};

/* Initialization function for the algorithm,
   gets called during allocation of the digest object.
   we override initialize to do custom hash size, so we don't care too much here.
*/
static int
keccak_init_func() {
  // Just return a 1 'successful' we override the init function
  // so this is not necessary
  // the base class alloc calls this to initialize the algorithm
  return 1;
}

/* Update function, take the current context and add str to it */
static void
keccak_update_func(hashState *ctx, unsigned char *str, size_t len) {
	Update(ctx, str, len * 8);
}

/* Finish the hash calculation and return the finished string */
static int
keccak_finish_func(hashState *ctx, unsigned char *digest) {
	Final(ctx, digest);
	return 1;
}

/* Ruby method.  Digest::Keccak#finish()
 * No Arguments
 * @returns [String] Encoded Digest String
 */
static VALUE
rb_keccak_finish(VALUE self) {
  hashState *ctx;
  VALUE digest;

  ctx = (hashState *)RTYPEDDATA_DATA(self);
  digest = rb_str_new(0, ctx->capacity / 2 / 8);
  keccak_finish_func(ctx, (unsigned char *)RSTRING_PTR(digest));

  return digest;
}

/* :nodoc: private method
 * initialize the ctx with the bitlength
 */
static void
keccak_init(hashState *ctx, size_t bitlen) {
	switch (Init(ctx, bitlen)) {
	case SUCCESS:
		return;
	case FAIL:
		rb_raise(rb_eRuntimeError, "Unknown error");
	case BAD_HASHLEN:
		rb_raise(rb_eArgError, "Bad hash length (must be 0, 224, 256, 384 or 512)");
	default:
		rb_raise(rb_eRuntimeError, "Unknown error code");
	}
}

/* Ruby method.  Digest::Keccak.new(hashlen)
 * @param hashlen The length of hash, only supports 224, 256, 384 or 512
 * @returns [Digest::Keccak] new object.
 */
static VALUE
rb_keccak_initialize(int argc, VALUE *argv, VALUE self) {
	hashState *ctx;
	VALUE hashlen;
	int i_hashlen;

	if (rb_scan_args(argc, argv, "01", &hashlen) == 0) {
		i_hashlen = DEFAULT_DIGEST_LEN;
	} else {
		i_hashlen = NUM2INT(hashlen);
	}
	if ( i_hashlen == 0) {
		rb_raise(rb_eArgError, "Unsupported hash length");
  }

  ctx = (hashState *)RTYPEDDATA_DATA(self);
	keccak_init(ctx, i_hashlen);

	return rb_call_super(0, NULL);
}

/* Ruby method.  Digest::Keccak#digest_length
 * @returns [Numeric] Length of the digest.
 */
static VALUE
rb_keccak_digest_length(VALUE self) {
	hashState *ctx;

	ctx = (hashState *)RTYPEDDATA_DATA(self);
	return INT2FIX(ctx->capacity / 2 / 8);
}

/* Ruby method.  Digest::Keccak#block_length
 * @returns [Numeric] Length of blocks in this digest.
 */
static VALUE
rb_keccak_block_length(VALUE self) {
	hashState *ctx;

	ctx = (hashState *)RTYPEDDATA_DATA(self);
	return INT2FIX(ctx->rate / 8);
}

void __attribute__((visibility("default")))
Init_keccak() {
	VALUE mDigest, cDigest_Base, cKeccak;

	rb_require("digest");

	mDigest = rb_path2class("Digest");
	cDigest_Base = rb_path2class("Digest::Base");

	cKeccak = rb_define_class_under(mDigest, "Keccak", cDigest_Base);

	rb_iv_set(cKeccak, "metadata", Data_Wrap_Struct(0, 0, 0, (void *)&keccak));

  rb_define_method(cKeccak, "initialize", rb_keccak_initialize, -1);
  rb_define_method(cKeccak, "digest_length", rb_keccak_digest_length, 0);
  rb_define_method(cKeccak, "block_length", rb_keccak_block_length, 0);
  rb_define_method(cKeccak, "finish", rb_keccak_finish, 0);
}
