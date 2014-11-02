module Table


  module Cell
    ##
    # Used for the purposes of headers and footers which will always be just text.
    class Text
      include Table::Cell::Base
      include HashAttributes

      ##
      # With no attribute passed text will be set to empty text and header
      # will be set to false.
      def initialize(options = {})
        set_attributes(options)
      end

      ##
      # Rowspan will always be 1
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