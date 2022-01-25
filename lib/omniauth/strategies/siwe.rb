# frozen_string_literal: true

module OmniAuth
  module Strategies
    class SIWE
      include OmniAuth::Strategy

      option :name, "siwe"
      option :provider_uid, "siwe"

      def request_phase
        redirect "/siwe/index?redirect_url=#{callback_url}"
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def callback_phase
        address = request.params["address"]
        ens = request.params["ens"]

        super
      end
    end
  end
end
