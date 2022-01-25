# frozen_string_literal: true

# name: discourse-siwe-auth
# about: Enable login via "Sign-In with Ethereum"
# version: 1.0
# author: Spruce Systems Inc.
# url: https://github.com/spruceid/discourse-siwe-auth

gem 'sass-rails', '6.0.0', require: true
# gem 'ffi', '>= 1.15.5', require: true
# gem 'ffi-compiler', '1.0.1', require: true
# gem 'scrypt', '~> 3.0', require: true
# gem 'rlp', '~> 0.7', require: true
# gem 'pkg-config', '1.4.7', require: true
# gem 'rake', '>= 13.0.6', require: true
# gem 'mini_portile2', '>= 2.7.1', require: true
# gem 'rbsecp256k1', '~> 5.1', require: true
# gem 'openssl', '~> 3.0', require: true
# gem 'konstructor', '~> 1.0', require: true
# gem 'keccak', '~> 1.3', require: true
# gem 'eth', '0.5.0', require: true
# gem 'hashie', '>= 5.0.0', require: true
# gem 'omniauth', '1.9.1', require: true
# gem 'rubyzip', '>= 2.3.2', require: true
# gem 'siwe', '0.1.5', require: true

require_relative 'lib/omniauth-siwe'

register_svg_icon 'fab-ethereum'

enabled_site_setting :siwe_enabled

after_initialize do

  module ::DiscourseSiweAuth
    PLUGIN_NAME ||= 'discourse-siwe-auth'

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace DiscourseSiweAuth
    end
  end

  %w[
    ../app/controllers/discourse_siwe_auth/siwe_controller.rb
  ].each { |path| load File.expand_path(path, __FILE__) }

  ::ActionController::Base.prepend_view_path File.expand_path(
                                               '../app/views',
                                               __FILE__
                                             )

  Discourse::Application.routes.append do
    mount ::DiscourseSiweAuth::Engine, at: '/'
  end

  DiscourseSiweAuth::Engine.routes.draw do
    get '/siwe/index' => 'siwe#index'
    post '/siwe/message' => 'siwe#message'
    post '/siwe/signature' => 'siwe#signature'
    post '/siwe/modal_config' => 'siwe#modal_config'
  end
end

class SiweAuthenticator < ::Auth::ManagedAuthenticator
  def name
    'siwe'
  end

  def enabled?
    SiteSetting.siwe_enabled?
  end

  def register_middleware(omniauth)
    omniauth.provider :SIWE,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                      }
  end
end

auth_provider icon: 'fab-ethereum',
              authenticator: SiweAuthenticator.new
