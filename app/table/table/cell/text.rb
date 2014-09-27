module Table

  #
  # = Table::Cell::Text
  #
  #  Used for the purposes of headers and footers which will always be just text.
  #
  #
  module Cell
    class Text
      include Table::Cell::Base

      def initialize(text = " ")
        @text = text
      end

      def span
        1
      end

    end
  end
end