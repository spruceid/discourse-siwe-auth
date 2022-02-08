# frozen_string_literal: true

module Secp256k1
  # Contains utility methods that complement the functionality of the library.
  module Util
    # Regexp to validate a hexadecimal string
    HEX_REGEXP = /^[A-Fa-f\d]+$/.freeze

    # Converts a binary string to a hex string.
    #
    # @param binary_string [String] binary string to be converted.
    # @return [String] hex string equivalent of the given binary string.
    def self.bin_to_hex(binary_string)
      binary_string.unpack('H*').first
    end

    # Converts a hex string to a binary string.
    #
    # @param hex_string [String] string with hexadeimcal value.
    # @return [String] binary string equivalent of the given hex string.
    # @raise [ArgumentError] if hex string is an invalid hexadecimal string.
    def self.hex_to_bin(hex_string)
      raise ArgumentError, "Invalid hexadecimal string" unless hex_string =~ HEX_REGEXP

      [hex_string].pack('H*')
    end
  end
end
