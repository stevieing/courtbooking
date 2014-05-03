module BookingSlots
  module Cell
    class Blank
      include Base

      def self.build(*args)
        new
      end

      def blank?
        true
      end
    end
  end
end