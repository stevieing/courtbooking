module BookingSlots
  module Cell
    class Closed < Base

      def self.build(*args)
        new
      end

      def closed?
        true
      end

      def klass
        "closed"
      end
    end
  end
end