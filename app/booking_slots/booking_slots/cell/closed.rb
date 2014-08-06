module BookingSlots
  module Cell
    class Closed
      include Base

      def self.build(*args)
        new(*args)
      end

      def initialize(table)
        @text, @span = " ", 1
        table.skip(@span)
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