# frozen_string_literal: true

module DiscourseSiweAuth
  class MessagesController < ApplicationController
    def pagedata
      render json: [{ name: "milk", description: "cold" }, { name: "bread", description: "toast" }, { name: "coffee", description: "hot" }]
    rescue StandardError => e
      render_json_error e.message
    end
  end
end
