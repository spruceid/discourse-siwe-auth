# -*- encoding: utf-8 -*-
# stub: rbsecp256k1 5.1.0 ruby ext lib
# stub: ext/rbsecp256k1/extconf.rb

Gem::Specification.new do |s|
  s.name = "rbsecp256k1".freeze
  s.version = "5.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["ext".freeze, "lib".freeze]
  s.authors = ["Eric Scrivner".freeze]
  s.date = "2021-12-01"
  s.extensions = ["ext/rbsecp256k1/extconf.rb".freeze]
  s.files = ["ext/rbsecp256k1/extconf.rb".freeze]
  s.homepage = "https://github.com/etscrivner/rbsecp256k1".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.31".freeze
  s.summary = "Native extension gem for secp256k1 ECDSA. Wraps libsecp256k1. In rbsecp256k1 3.0.0 and later libsecp256k1 is bundled with the gem.".freeze

  s.installed_by_version = "3.2.31" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<mini_portile2>.freeze, ["~> 2.7"])
    s.add_runtime_dependency(%q<pkg-config>.freeze, ["~> 1.4"])
    s.add_runtime_dependency(%q<rubyzip>.freeze, ["~> 2.3"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.1"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8"])
    s.add_development_dependency(%q<rubocop>.freeze, ["= 0.78"])
    s.add_development_dependency(%q<yard>.freeze, ["~> 0.9"])
  else
    s.add_dependency(%q<mini_portile2>.freeze, ["~> 2.7"])
    s.add_dependency(%q<pkg-config>.freeze, ["~> 1.4"])
    s.add_dependency(%q<rubyzip>.freeze, ["~> 2.3"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.1"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.8"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.78"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
  end
end
