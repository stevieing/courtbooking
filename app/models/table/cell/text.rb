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
      include HashAttributes

      def initialize(options = {})
        set_attributes(options)
      end

      def span
        1
      end

      def header?
        @header
      end

    private

      def default_attributes
        {text: " ", header: false}
      end

    end
  end
end