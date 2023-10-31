# frozen_string_literal: true

# name: discourse-siwe
# about: A discourse plugin to enable users to authenticate via Sign In with Ethereum
# version: 0.1.2

enabled_site_setting :discourse_siwe_enabled
register_svg_icon 'fab-ethereum'
register_asset 'stylesheets/discourse-siwe.scss'

%w[
  ../lib/omniauth/strategies/siwe.rb
].each { |path| load File.expand_path(path, __FILE__) }

gem 'pkg-config', '1.5.0', require: false
gem 'forwardable', '1.3.3', require: false
gem 'mkmfmf', '0.4', require: false
gem 'keccak', '1.3.0', require: false
gem 'zip', '2.0.2', require: false
gem 'mini_portile2', '2.8.0', require: false
gem 'rbsecp256k1', '6.0.0', require: false
gem 'konstructor', '1.0.2', require: false
gem 'ffi', '1.16.3', require: false
gem 'ffi-compiler', '1.0.1', require: false
gem 'scrypt', '3.0.7', require: false
gem 'eth', '0.5.11', require: false
gem 'siwe', '1.1.2', require: false

class ::SiweAuthenticator < ::Auth::ManagedAuthenticator
  def name
    'siwe'
  end

  def register_middleware(omniauth)
    omniauth.provider :siwe,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                      }
  end

  def enabled?
    SiteSetting.discourse_siwe_enabled
  end

  def primary_email_verified?
    false
  end
end

auth_provider authenticator: ::SiweAuthenticator.new,
              icon: 'fab-ethereum',
              full_screen_login: true

after_initialize do
  %w[
    ../lib/discourse_siwe/engine.rb
    ../lib/discourse_siwe/routes.rb
    ../app/controllers/discourse_siwe/auth_controller.rb
  ].each { |path| load File.expand_path(path, __FILE__) }

  Discourse::Application.routes.prepend do
    mount ::DiscourseSiwe::Engine, at: '/discourse-siwe'
  end
end
