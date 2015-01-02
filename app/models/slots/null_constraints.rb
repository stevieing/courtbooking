module Slots

  ##
  # NullConstraints allows for the removal of decision trees in mainly the series
  # and the slots class. This could be expanded further into general application
  # configuration.
  class NullConstraints

    ##
    # NullConstraints will never be valid.
    # Eventually this can be changed by replacing all standard methods.
    def valid?
      false
    end

    ##
    # This will never return a valid time.
    # This prevents a series being created.
    def slot_time
      0
    end

    def covers_last?(slot)
      false
    end
  end
end