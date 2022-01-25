# frozen_string_literal: true

module OmniAuth
  module Strategies
    class SIWE
      include OmniAuth::Strategy
      
      uid do
        request.params["ens"].nil? ? request.params["ens"] : request.params["address"]
      end

      info do
        {}
      end

      option :name, "siwe"
      option :provider_uid, "siwe"

      def request_phase
        redirect "/siwe/index?redirect_url=#{callback_url}"
      end

      def callback_url
        '/auth/siwe/callback'
      end

      def callback_phase
        @address = request.params["address"]
        @ens = request.params["ens"]
        super
      end
    end
  end
end
