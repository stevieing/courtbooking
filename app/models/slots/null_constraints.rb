module Slots
  class NullConstraints
    def valid?
      false
    end

    def slot_time
      0
    end
  end
end