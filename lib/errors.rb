# frozen_string_literal: true

module Errors
  class EmptyStringError < StandardError
    def initialize
      super('You try to send empty string!')
    end
  end

  class WrongSymbolError < StandardError
    def initialize
      super('Element must be Symbol!')
    end
  end
end
