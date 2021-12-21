module SIWE
  class Engine < ::Rails::Engine
    isolate_namespace SIWE

    config.after_initialize do
      Discourse::Application.routes.append do
        mount ::SIWE::Engine, at: "/"
      end
    end
  end
end
