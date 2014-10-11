module Table
  module Cell
    class Blank
      def blank?
        true
      end
      def to_html
        nil
      end
    end
  end
end