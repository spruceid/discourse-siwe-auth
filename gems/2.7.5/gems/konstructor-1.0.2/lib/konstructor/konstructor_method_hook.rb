module Konstructor
  # @private
  module KonstructorMethodHook # :nodoc:

    # Experimental and currently not used <code>method_added</code>
    # hook approach protecting against method_added
    # overrides that are not calling super (hopefully, there is no such code in the wild).
    #
    # Since method_added hook is idempotent, there would be no harm done even if
    # overridding method_added actually had super call and Konstructor's hook would be
    # called twice as a result of this.
    def self.setup(base)
      method_added_method = base.method(:method_added)
      if method_added_method.source_location
        method_added_file_path = method_added_method.source_location.first
        return if method_added_file_path.include?('konstructor_method_hook')
      end

      base.instance_exec do
        private

        alias konstructor_super_method_added method_added

        def method_added(name)
          Konstructor.method_added_to_klass(self, name)
          konstructor_super_method_added(name)
        end
      end
    end

  end
end