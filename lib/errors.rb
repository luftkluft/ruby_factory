# frozen_string_literal: true

module Errors
  class WrongClassError < StandardError
    def initialize
      super('Wrong class!')
    end
  end

  class EmptyStringError < StandardError
    def initialize
      super('You try to send empty string!')
    end
  end

  class UndefinedLibraryEntity < StandardError
    def initialize
      super('Library accepts only Book, Author, Order, Reader classes!')
    end
  end

  class WrongSymbolError < StandardError
    def initialize
      super('Element must be Symbol!')
    end
  end
end
