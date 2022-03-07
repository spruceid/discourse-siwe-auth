module OmniAuth
  module Strategies
    class Siwe
      include OmniAuth::Strategy

      option :fields, %i[eth_message eth_account eth_signature]
      option :uid_field, :eth_account

      uid do
        request.params[options.uid_field.to_s]
      end

      info do
        {
          name: request.params[options.uid_field.to_s],
          image: request.params['eth_avatar']
        }
      end

      def request_phase
        query_string = env['QUERY_STRING']
        redirect "/discourse-siwe/auth?#{query_string}"
      end

      def callback_phase
        eth_message_crlf = request.params['eth_message']
        eth_message = eth_message_crlf.encode(eth_message_crlf.encoding, universal_newline: true)
        eth_signature = request.params['eth_signature']
        siwe_message = ::Siwe::Message.from_message(eth_message)

        domain = Discourse.base_url
        domain.slice!("#{Discourse.base_protocol}://")
        if siwe_message.domain != domain
          return fail!("Invalid domain")
        end

        if siwe_message.nonce != session[:nonce]
          return fail!("Invalid nonce")
        end

        failure_reason = nil
        begin
          siwe_message.validate(eth_signature)
        rescue Siwe::ExpiredMessage
          failure_reason = :expired_message
        rescue Siwe::NotValidMessage
          failure_reason = :invalid_message
        rescue Siwe::InvalidSignature
          failure_reason = :invalid_signature
        end

        return fail!(failure_reason) if failure_reason

        super
      end
    end
  end
end
