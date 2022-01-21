# frozen_string_literal: true

# name: discourse-siwe-auth
# about: Enable login via "Sign-In with Ethereum"
# version: 1.0
# author: Spruce Systems Inc.
# url: https://github.com/spruceid/discourse-siwe-auth

require_relative 'lib/omniauth-siwe'

register_asset 'stylesheets/application.css'
register_asset 'stylesheets/background.scss'
register_svg_icon 'fab-ethereum'

enabled_site_setting :siwe_enabled

Discourse::Application.routes.append do
  get '/siwe/index' => 'discourse_siwe_auth/siwe#index'
  post '/siwe/message' => 'discourse_siwe_auth/siwe#message'
  post '/siwe/signature' => 'discourse_siwe_auth/siwe#signature'
end

load File.expand_path('../lib/engine.rb', __FILE__)

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
