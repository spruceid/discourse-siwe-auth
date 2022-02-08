# frozen_string_literal: true

# Wraps libsecp256k1 in a ruby module and provides object interfaces.
module Secp256k1
end

require 'rbsecp256k1/context'
require 'rbsecp256k1/util'
require 'rbsecp256k1/version'
require 'rbsecp256k1/rbsecp256k1'
