# frozen_string_literal: true

# name: discourse-siwe-auth
# about: Enable login via "Sign-In with Ethereum"
# version: 1.0
# author: Spruce Systems Inc.
# url: https://github.com/spruceid/discourse-siwe-auth

gem 'sass-rails', '6.0.0', require: true

require_relative 'lib/omniauth-siwe'

register_asset 'javascripts/siwe.js.erb'
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
  end
end

# Discourse::Application.routes.append do
#   get '/siwe/index' => 'discourse_siwe_auth/siwe#oidc'
#   post '/siwe/message' => 'discourse_siwe_auth/siwe#message'
#   post '/siwe/signature' => 'discourse_siwe_auth/siwe#signature'
# end

# load File.expand_path('../lib/engine.rb', __FILE__)

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
