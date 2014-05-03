module BookingSlots
  module Cell
    class Closed
      include Base

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