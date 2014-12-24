module Slots

  ##
  # This is especially useful when a number of series are combined
  # For example to close slots. It saves checking whether there are any
  # slots and can just return an empty series.
  class NullSeries

    ##
    # This will always return an empty range.
    def range
      []
    end

    ##
    # The all method is synonymous with the range.
    alias_method :all, :range
  end
end