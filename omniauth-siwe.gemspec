require File.expand_path('lib/omniauth-siwe/version', __dir__)

Gem::Specification.new do |gem|
  gem.author        = 'Spruce Systems Inc.'
  gem.email         = ['hello@spruceid.com']
  gem.description   = 'A generic strategy for OmniAuth to authenticate with Ethereum wallets.'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/spruceid/omniauth-siwe'

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'siwe', '~> 1.0'
  gem.add_development_dependency 'bundler', '~> 1.9'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'omniauth-siwe'
  gem.require_paths = ['lib']
  gem.version       = OmniAuth::SIWE::VERSION
end
