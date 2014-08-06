module BookingSlots
  module Cell
    class Text
      include Base

      def initialize(text = " ")
        @text = text
      end

      def link
        nil
      end

      def klass
        nil
      end

      def span
        1
      end

    end
  end
end