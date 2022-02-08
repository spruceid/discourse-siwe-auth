# -*- encoding: utf-8 -*-
# stub: konstructor 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "konstructor".freeze
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dima Lashkov".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-02-02"
  s.description = "\n    Konstructor is a small gem that gives you multiple constructors in Ruby.\n    It's similar to having overloaded constructors in other languages.\n  ".freeze
  s.email = ["dm.lashkov@gmail.com".freeze]
  s.homepage = "https://github.com/snovity/konstructor".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.2.31".freeze
  s.summary = "Multiple constructors in Ruby.".freeze

  s.installed_by_version = "3.2.31" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.13"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<pry-byebug>.freeze, ["~> 3.4"])
    s.add_development_dependency(%q<activesupport>.freeze, ["~> 4.2"])
    s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.8.19"])
    s.add_development_dependency(%q<thor>.freeze, ["= 0.19.4"])
    s.add_development_dependency(%q<contracts>.freeze, ["= 0.14.0"])
    s.add_development_dependency(%q<constructor>.freeze, ["= 2.0.0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.4"])
    s.add_dependency(%q<activesupport>.freeze, ["~> 4.2"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.8.19"])
    s.add_dependency(%q<thor>.freeze, ["= 0.19.4"])
    s.add_dependency(%q<contracts>.freeze, ["= 0.14.0"])
    s.add_dependency(%q<constructor>.freeze, ["= 2.0.0"])
  end
end
