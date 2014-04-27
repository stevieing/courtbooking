module BookingSlots
  module Cell
    class Blank < Base

      def self.build(*args)
        new
      end

      def blank?
        true
      end
    end
  end
end