# frozen_string_literal: true

module ::DiscourseSiwe
  PLUGIN_NAME ||= 'discourse-siwe'
  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseSiwe
  end
end
