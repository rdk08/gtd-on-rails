module State
  extend ActiveSupport::Concern

  included do
    def state
      self.symbol.to_sym
    end

    def state_name
      self.display_name
    end
  end

  class_methods do
    def get_object(symbol)
      symbol_s = symbol.to_s
      self.find_by symbol: symbol_s
    end
  end

end
