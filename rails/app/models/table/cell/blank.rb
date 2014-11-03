module Table
  module Cell
    class Blank
      include Table::Cell::Base

      def blank?
        true
      end

      def to_html(tag = :td)
        nil
      end

    end
  end
end