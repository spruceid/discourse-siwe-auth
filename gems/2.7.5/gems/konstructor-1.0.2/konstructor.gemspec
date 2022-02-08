# coding: utf-8
# require_relative 'lib/konstructor/version' <- doesn't work with Ruby 1.9.3 in gemspec when building gem
require File.expand_path('../lib/konstructor/version', __FILE__)


Gem::Specification.new do |spec|
  spec.name          = 'konstructor'
  spec.version       = Konstructor::VERSION
  spec.authors       = ['Dima Lashkov']
  spec.email         = ['dm.lashkov@gmail.com']

  spec.summary       = %q{Multiple constructors in Ruby.}
  # few paragraphs with no examples or formatting
  spec.description   = %q{
    Konstructor is a small gem that gives you multiple constructors in Ruby.
    It's similar to having overloaded constructors in other languages.
  }
  spec.homepage      = 'https://github.com/snovity/konstructor'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  # the reason to use exe is to distinguish between gem development binaries
  # and gem runtime binaries
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.4'
  spec.add_development_dependency 'activesupport', '~> 4.2'
  spec.add_development_dependency 'coveralls', '~> 0.8.19'

  # to test conflicts, specifying precise versions since below version 1 and no semver guarantees
  spec.add_development_dependency 'thor', '0.19.4'
  spec.add_development_dependency 'contracts', '0.14.0'
  spec.add_development_dependency 'constructor', '2.0.0'
end
