# frozen_string_literal: true
require 'siwe'
module DiscourseSiweAuth
  class SiweController < ::ApplicationController
    SESSION_SIWE_MESSAGE_KEY = 'siwe_message'

    skip_before_action :check_xhr, only: [ :index, :modal_config, :message, :signature ]
    layout "discourse_siwe_auth/siwe/layout"

    # /#{prefix}/index
    def index
      @redirect_url = params[:redirect_url]
      render 'discourse_siwe_auth/siwe/index'
    end

    def modal_config
      render json: {
        prefix: SiteSetting.siwe_prefix,
        network: SiteSetting.siwe_network,
        INFURA_ID: SiteSetting.siwe_infura_id,
        TORUS: SiteSetting.siwe_torus,
        PORTIS_ID: SiteSetting.siwe_portis_id,
        FORTMATIC_KEY: SiteSetting.siwe_fortmatic_key,
        COINBASE: SiteSetting.siwe_coinbase,
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
        render json: { ens: params[:ens], address: message.address }
      else
        head :bad_request
      end
    end

    private

    # Calculates expiration date
    def expires_at
      (Time.now.utc + SiteSetting.siwe_expiration_time).iso8601
    end

    # Calculates expiration date
    def not_before
      (Time.now.utc + SiteSetting.siwe_not_before).iso8601
    end

    # Default required params
    def default_sign_params
      {
        statement: SiteSetting.siwe_statement,
        nonce: Siwe::Util.generate_nonce,
        chain_id: request.params[:chainId]
      }
    end

    # Add optional params if present
    def sign_params
      params = default_sign_params
      params[:expiration_time] = expires_at unless SiteSetting.siwe_expiration_time.nil?
      params[:not_before] = not_before unless SiteSetting.siwe_not_before.nil?
      params[:request_id] = SecureRandom.uuid if SiteSetting.siwe_request_id
      # params[:resources] = SiteSetting.siwe_resources unless SiteSetting.siwe_resources.nil?
      params
    end

    # Returns redirection URL
    def redirect_uri(ens, address)
      "doweneed?ens=#{ens}&address=#{address}"
    end
  end
end
