module Konstructor

  # Base class for all Konstructor errors.
  class Error < StandardError
  end

  # Raised if reserved names <code>new</code> or <code>initialize</code>
  # are used in declaration.
  class ReservedNameError < Error
    def initialize(name)
      super "Custom constructor can't have name '#{name}', "
            "it is reserved for default constructor."
    end
  end

  # Raised if declaring inherited method as constructor.
  class DeclaringInheritedError < Error
    def initialize(name)
      super "You are declaring an inherited method '#{name}' as konstructor, "
            "this is not allowed."
    end
  end

  # Raised if <code>konstructor</code> is used inside module.
  class IncludingInModuleError < Error
    def initialize(base)
      super "Konstructor can't be included in module '#{base.name}' directly, " +
            "please, use ActiveSupport::Concern or standard included hook."
    end
  end

end