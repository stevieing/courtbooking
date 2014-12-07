module Table
  module Cell
    class Empty

      include Table::Cell::Base

      attr_reader :slot

      def initialize(slot = nil)
        @slot = slot
      end

      def text
        ""
      end

      def span
        0
      end

      def to_html(tag = :td)
        content_tag tag, ""
      end

      def empty?
        true
      end
    end
  end
end