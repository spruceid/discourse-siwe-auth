module Konstructor
  # @private
  module SimpleMethodHook # :nodoc:

    private

    def method_added(name)
      Konstructor.method_added_to_klass(self, name)
      super
    end

    def self.setup(base)
      class << base
        # Ruby itself checks against double include
        include Konstructor::SimpleMethodHook
      end
    end

  end
end
