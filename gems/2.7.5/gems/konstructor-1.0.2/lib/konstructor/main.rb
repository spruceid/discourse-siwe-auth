require 'konstructor/version'
require 'konstructor/exceptions'
require 'konstructor/simple_method_hook'
require 'konstructor/factory'

module Konstructor

  module KonstructorMethod
    private

    # konstructor                 -> nil or
    # konstructor(symbol, ...)    -> nil or
    # konstructor(string, ...)    -> nil
    #
    # If used without params, declares next method as constructor.
    #
    #   module SomeClass
    #     attr_reader :val
    #
    #     konstructor
    #     def create(val)
    #       @val = val
    #     end
    #   end
    #
    # If names are given, call can be placed anywhere, only methods with
    # those names will be declared as constructors.
    #
    #   module SomeClass
    #     attr_reader :val
    #
    #     def create(val)
    #       @val = val
    #     end
    #
    #     konstructor :create, :recreate
    #
    #     def recreate(val)
    #       @val = val * 2
    #     end
    #   end
    #
    # <em>then:</em>
    #
    #   SomeClass.new.val
    #   => nil
    #   SomeClass.create(3).val
    #   => 3
    #   SomeClass.recreate(3).val
    #   => 6
    #
    # Can be used multiple times with various arguments,
    # all calls add up without overwriting each other.
    #
    # Can raise several errors inheriting from <code>Konstructor::Error</code>:
    #   ReservedNameError
    #   DeclaringInheritedError
    #   IncludingInModuleError
    #
    # @!visibility public
    def konstructor(*several_variants) # :doc:
      Konstructor.declare(self, several_variants)
      nil
    end
  end

  DEFAULT_NAMES = [:initialize]
  RESERVED_NAMES = [:new, :initialize]

  extend MonitorMixin

  class << self
    def reserved?(name)
      RESERVED_NAMES.include?(name.to_sym)
    end

    def default?(name)
      DEFAULT_NAMES.include?(name.to_sym)
    end

    # Once method is a konstructor, it is always a konstructor, this differs
    # from the way private, protected works. If overriding method isn't repeatedly
    # marked as private it becomes public.
    def declared?(klass, method_name)
      konstructor = get_factory(klass)
      if konstructor
        konstructor.declared?(method_name.to_sym)
      else
        false
      end
    end

    def declare(klass, new_method_names)
      setup_method_added_hook(klass)
      synchronize do
        get_or_init_factory(klass).declare(new_method_names)
      end
    end

    def method_added_to_klass(klass, method_name)
      synchronize do
        get_or_init_factory(klass).method_added_to_klass(method_name)
      end
    end

    def is?(klass, method_name)
      default?(method_name) || declared?(klass, method_name)
    end

    private

    def get_factory(klass)
      klass.instance_variable_get(:@konstructor)
    end

    def init_factory(klass)
      # using variable @konstructor to minimize footprint, although saving factory there
      klass.instance_variable_set(:@konstructor, Factory.new(klass))
    end

    def get_or_init_factory(klass)
      get_factory(klass) || init_factory(klass)
    end

    def setup_method_added_hook(klass)
      SimpleMethodHook.setup(klass)
    end

    # Overriden append_features prevents default behavior
    # of including all the constants, variables to the base class.
    # It adds only one method 'konstructor'.
    def append_features(klass)
      unless klass.is_a? Class
        raise IncludingInModuleError, klass
      end

      klass.extend(KonstructorMethod)
    end
  end

end