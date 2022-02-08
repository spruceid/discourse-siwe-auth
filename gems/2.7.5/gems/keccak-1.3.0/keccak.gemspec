# frozen_string_literal: true

lib = File.expand_path('lib', __dir__).freeze
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'digest/keccak/version'

Gem::Specification.new do |spec|
  spec.name = "keccak"
  spec.version = Digest::Keccak::VERSION
  spec.summary = "The Keccak (SHA3) hash used by Ethereum."
  spec.description = "The Keccak (SHA3) hash used by Ethereum. This does not implement the final FIPS202 standard, today known as SHA3 but rather an early version, commonly referred to as Keccak."
  spec.homepage = "https://github.com/q9f/keccak.rb"
  spec.authors = ["Afri Schoedon", "Alex Kotov", "Chris Metcalfe", "Hongli Lai (Phusion)", "Keccak authors"]
  spec.email = "%w[ruby@q9f.cc]"
  spec.extensions << "ext/digest/extconf.rb"
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.2", "< 4.0"
  spec.license = "Apache-2.0"
  spec.metadata = {
    'homepage_uri'    => 'https://github.com/q9f/keccak.rb',
    'source_code_uri' => 'https://github.com/q9f/keccak.rb',
    'github_repo'     => 'https://github.com/q9f/keccak.rb',
    'bug_tracker_uri' => 'https://github.com/q9f/keccak.rb/issues',
  }.freeze
  spec.require_paths = ['lib']
  spec.files = Dir[
    "README.md",
    "COPYRIGHT",
    "LICENSE",
    "Makefile",
    "keccak.gemspec",
    "ext/**/*.{c,h,rb}",
    "lib/**/*"
  ]
  spec.test_files = spec.files.grep %r{^(test|spec|features)/}
  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'test-unit', '~> 3.4'
end
