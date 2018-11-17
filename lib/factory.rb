# frozen_string_literal: true

class Factory
  class << self
  def new(*keys, &block)
    raise ArgumentError, 'Empty initialize' if keys.empty?

    if keys.first.is_a? String
      const_set(keys.shift.capitalize, build_class(*keys, &block))
    else
      build_class(*keys, &block)
    end
  end

  def build_class(*keys, &block)
    Class.new do
      attr_accessor(*keys)
      class_eval(&block) if block_given?

      define_method :initialize do |*keys_data|
        raise ArgumentError, 'Mismatch number of arguments' if keys.count != keys_data.count

        keys.zip(keys_data).each { |arg, value| send("#{arg}=", value) }
      end

      def [](arg)
        return instance_variable_get(instance_variables[arg]) if arg.is_a?(Integer)

        instance_variable_get("@#{arg}")
      end

      def []=(arg, value)
        instance_variable_set(instance_variables[arg], value) if arg.is_a?(Integer)
        instance_variable_set(:"@#{arg}", value)
      end

      def ==(other)
        compare(other) { |ffalse, sself, oother| ffalse && (sself == oother) }
      end

      def compare(other)
        instance_variables.inject(true) do |ffalse, variable|
          return false unless ffalse

          begin
            sself = instance_variable_get(variable)
            oother = other.instance_variable_get(variable)
            yield(ffalse, sself, oother) if block_given?
          rescue StandardError
            false
          end
        end
      end

      def dig(*args)
        to_h.dig(*args)
      end

      def to_h
        Hash[instance_variables.map do |name|
          [name.to_s.delete('@').to_sym,
           instance_variable_get(name)]
        end]
      end

      def each(&value)
        to_a.each(&value)
      end

      def to_a
        instance_variables.map { |variable| instance_variable_get(variable) }
      end

      def each_pair(&name_value)
        to_h.each_pair(&name_value)
      end

      def length
        to_a.size
      end

      alias_method :size, :length

      def members
        instance_variables.map { |variable| variable.to_s.delete('@').to_sym }
      end

      def select(&member_value)
        to_a.select(&member_value)
      end

      def values_at(*indexes)
        indexes.map do |index|

          to_a[index]
        end
      end
    end
  end
end
end
