module Slots
  module Cell
    class Closed < Slots::Cell::Text

      def closed?
        true
      end

      def html_class
        "closed"
      end

    end
  end
end