# -*- encoding: utf-8 -*-
# stub: keccak 1.3.0 ruby lib
# stub: ext/digest/extconf.rb

Gem::Specification.new do |s|
  s.name = "keccak".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/q9f/keccak.rb/issues", "github_repo" => "https://github.com/q9f/keccak.rb", "homepage_uri" => "https://github.com/q9f/keccak.rb", "source_code_uri" => "https://github.com/q9f/keccak.rb" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Afri Schoedon".freeze, "Alex Kotov".freeze, "Chris Metcalfe".freeze, "Hongli Lai (Phusion)".freeze, "Keccak authors".freeze]
  s.date = "2021-12-01"
  s.description = "The Keccak (SHA3) hash used by Ethereum. This does not implement the final FIPS202 standard, today known as SHA3 but rather an early version, commonly referred to as Keccak.".freeze
  s.email = "%w[ruby@q9f.cc]".freeze
  s.extensions = ["ext/digest/extconf.rb".freeze]
  s.files = ["ext/digest/extconf.rb".freeze]
  s.homepage = "https://github.com/q9f/keccak.rb".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new([">= 2.2".freeze, "< 4.0".freeze])
  s.rubygems_version = "3.2.31".freeze
  s.summary = "The Keccak (SHA3) hash used by Ethereum.".freeze

  s.installed_by_version = "3.2.31" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 2.2"])
    s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.4"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 2.2"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.4"])
  end
end
