module Slots
  module Cell
    class Text
      include Slots::Cell::Base

      def initialize(text = " ")
        @text = text
      end

      def span
        1
      end

    end
  end
end