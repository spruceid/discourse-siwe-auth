# frozen_string_literal: true

# name: discourse-siwe-auth
# about: Enable login via "Sign-In with Ethereum"
# version: 1.0
# author: Spruce Systems Inc.
# url: https://github.com/spruceid/discourse-siwe-auth

require_relative 'lib/omniauth-siwe'

register_svg_icon 'fab-ethereum'

enabled_site_setting :sign_in_with_ethereum_enabled

Discourse::Application.routes.append do
  get '/siwe/message' => 'discourse_siwe_auth/messages#pagedata'
end

load File.expand_path('../lib/engine.rb', __FILE__)

after_initialize do
  @custom_footer = <<-EOF.strip_heredoc.chomp
    <div>
    <h3>Discourse New Footer</h3>
    </div>
EOF

  register_custom_html footer: @custom_footer
end

class EthereumAuthenticator < ::Auth::ManagedAuthenticator
  def name
    'siwe'
  end

  def enabled?
    SiteSetting.sign_in_with_ethereum_enabled?
  end

  def register_middleware(omniauth)
    omniauth.provider :SIWE,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                      }
  end
end

auth_provider icon: 'fab-ethereum',
              authenticator: EthereumAuthenticator.new
