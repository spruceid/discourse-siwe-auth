# frozen_string_literal: true
require 'siwe'

module DiscourseSiweAuth
  class SiweController < ::ApplicationController
    skip_before_action :check_xhr, only: [ :index, :modal_config, :message, :signature ]
    layout "discourse_siwe_auth/siwe/layout"

    # /#{prefix}/index
    def index
      @redirect_url = params[:redirect_url]
      render 'discourse_siwe_auth/siwe/index'
    end

    def modal_config
      render json: {
        siwe_prefix: SiteSetting.siwe_prefix,
        siwe_network: SiteSetting.siwe_network,
        siwe_infura_id: SiteSetting.siwe_infura_id,
        siwe_torus: SiteSetting.siwe_torus,
        siwe_portis_id: SiteSetting.siwe_portis_id,
        siwe_fortmatic_key: SiteSetting.siwe_fortmatic_key,
        siwe_coinbase: SiteSetting.siwe_coinbase,
      }
    end

    # /#{prefix}/message
    def message
      message = Siwe::Message.new(
        request.host,
        request.params[:address],
        request.url,
        '1',
        sign_params
      )
      session[SESSION_SIWE_MESSAGE_KEY] = message.to_json_string
      render plain: message.personal_sign
    end

    # /#{prefix}/signature
    def signature
      message = Siwe::Message.from_json_string session[SESSION_SIWE_MESSAGE_KEY]
      message.signature = params.require(:signature)

      if message.validate
        session[SESSION_SIWE_MESSAGE_KEY] = nil
        redirect_to redirect_uri(params[:ens], message.address)
      else
        head :bad_request
      end
    end

    private

    # Calculates expiration date
    def expires_at
      (Time.now.utc + SiweRails.expiration_time).iso8601
    end

    # Default required params
    def default_sign_params
      {
        statement: SiweRails.statement,
        nonce: Siwe::Util.generate_nonce,
        chain_id: request.params[:chainId]
      }
    end

    # Add optional params if present
    def sign_params
      params = default_sign_params
      params[:expiration_time] = expires_at unless SiweRails.expiration_time.nil?
      params[:not_before] = SiweRails.not_before unless SiweRails.not_before.nil?
      params[:request_id] = SecureRandom.uuid if SiweRails.request_id
      params[:resources] = SiweRails.resources unless SiweRails.resources.nil?
      params
    end

    # Returns redirection URL
    def redirect_uri(ens, address)
      "#{SiweRails.redirect_uri}?ens=#{ens}&address=#{address}"
    end
  end
end
