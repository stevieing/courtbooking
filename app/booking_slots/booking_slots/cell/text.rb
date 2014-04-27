module BookingSlots
  module Cell
    class Text < Base

      def initialize(text = "&nbsp;")
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