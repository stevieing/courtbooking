module Slots
  class NullSeries

    def range
      []
    end

    alias_method :all, :range
  end
end