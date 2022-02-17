# frozen_string_literal: true

require 'siwe'
module DiscourseSiwe
  class AuthController < ::ApplicationController
    def index
    end

    def message
      eth_account = params[:eth_account]
      message = Siwe::Message.new(Discourse.base_url, eth_account, Discourse.base_url, "1", {
        issued_at: Time.now.utc.iso8601,
        statement:  ::DiscourseSiwe::MESSAGE ,
        nonce: Siwe::Util.generate_nonce,
        chain_id: params[:chain_id],
      })
    
      render json: { message: message.prepare_message }
    end
  end
end
