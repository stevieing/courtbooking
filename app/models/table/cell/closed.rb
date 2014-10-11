module Table
  module Cell
    class Closed < Table::Cell::Text

      def closed?
        true
      end

      def html_class
        "closed"
      end

    end
  end
end