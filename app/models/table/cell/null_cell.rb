module Table
  module Cell
    class NullCell

      include ActionView::Helpers::TagHelper

      def initialize
      end

      def text
        ""
      end

      def link
        nil
      end

      def html_class
        nil
      end

      def blank?
        false
      end

      def link?
        false
      end

      def span
        0
      end

      def header?
        false
      end

      def to_html
        content_tag :td, ""
      end
    end
  end
end