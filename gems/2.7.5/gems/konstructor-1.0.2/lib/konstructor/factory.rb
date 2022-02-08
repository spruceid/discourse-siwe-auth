module Konstructor
  # @private
  class Factory # :nodoc:

    def initialize(klass)
      @klass = klass
      @konstructor_names = []
      # converting string to symbol for much quicker hash lookups
      @thread_next_method_var_name = :"konstructor#{object_id}"
      reset_next_method_is_konstructor!
    end

    def declare(new_names)
      if new_names.empty?
        next_method_is_konstructor!
      else
        reset_next_method_is_konstructor!
        process_new_names(new_names)
      end
    end

    def declared?(name)
      declared_in_self?(name) || declared_in_superclass?(name)
    end

    def method_added_to_klass(name)
      name = name.to_sym

      if next_method_is_konstructor?
        reset_next_method_is_konstructor!
        @konstructor_names << name
        process_declaration(name)
      elsif declared?(name)
        process_declaration(name)
      end
    end

    private

    def next_method_is_konstructor!
      Thread.current[@thread_next_method_var_name] = true
    end

    def reset_next_method_is_konstructor!
      Thread.current[@thread_next_method_var_name] = false
    end

    def next_method_is_konstructor?
       Thread.current[@thread_next_method_var_name]
    end

    def declared_in_self?(name)
      @konstructor_names.include?(name.to_sym)
    end

    def declared_in_superclass?(name)
      current_klass = @klass

      # looking for superclass with Konstructor class instance
      while current_klass.respond_to?(:superclass) && current_klass.superclass.respond_to?(:konstructor, true)
        current_klass = current_klass.superclass
        return true if Konstructor.declared?(current_klass, name)
      end

      false
    end

    def process_new_names(new_names)
      new_names = new_names.map(&:to_sym)
      @konstructor_names.concat(new_names)

      new_names.each do |name|
        if method_in_hierarchy?(name)
          process_declaration(name)
        else
          # not sure if method will ever be defined,
          # but validating its name anyway
          validate_name!(name)
        end
      end
    end

    def method_in_hierarchy?(name)
      method_defined?(@klass, name)
    end

    def method_on_superclass?(name)
      @klass.respond_to?(:superclass) && method_defined?(@klass.superclass, name)
    end

    def method_defined?(klass, name)
      klass.method_defined?(name) || klass.private_method_defined?(name)
    end

    # this method is idempotent
    def process_declaration(name)
      validate_name!(name)

      if method_on_superclass?(name) && !declared_in_superclass?(name)
        raise DeclaringInheritedError, name
      end

      define_factory(name)
      mark_as_private(name)
    end

    def define_factory(name)
      # this works roughly 5 times slower on Ruby 2.3 than block version,
      # probably because block version is converted to byte code
      # @klass.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
      #   def #{name}(*args, &block)
      #     instance = allocate
      #     instance.__send__(:#{name}, *args, &block)
      #     instance
      #   end
      # RUBY

      @klass.define_singleton_method(name) do |*args, &block|
        instance = allocate
        instance.send(name, *args, &block)
        instance
      end
    end

    def mark_as_private(name)
      @klass.__send__(:private, name)
    end

    def validate_name!(name)
      if Konstructor.reserved?(name)
        raise ReservedNameError, name
      end
    end
  end
end