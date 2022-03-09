# frozen_string_literal: true

require 'siwe'
module DiscourseSiwe
  class AuthController < ::ApplicationController
    def index
    end

    def message
      eth_account = params[:eth_account]
      domain = Discourse.base_url
      domain.slice!("#{Discourse.base_protocol}://")
      message = Siwe::Message.new(domain, eth_account, Discourse.base_url, "1", {
        issued_at: Time.now.utc.iso8601,
        statement: SiteSetting.siwe_statement,
        nonce: Siwe::Util.generate_nonce,
        chain_id: params[:chain_id],
      })
      session[:nonce] = message.nonce

      render json: { message: message.prepare_message }
    end
  end
end
