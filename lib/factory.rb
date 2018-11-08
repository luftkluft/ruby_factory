# frozen_string_literal: true

class Factory
  def self.new(*keys, &block)
    raise ArgumentError, 'Wrong number of arguments (0 for 1+)' if keys.empty?

    Class.new do
      attr_accessor(*keys)
      class_eval(&block) if block_given?
    end
  end
end
