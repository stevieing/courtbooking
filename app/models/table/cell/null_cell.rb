module Table
  module Cell
    class NullCell

      include Table::Cell::Base

      def text
        ""
      end

      def span
        0
      end

      def to_html(tag = :td)
        content_tag tag, ""
      end
    end
  end
end