module Table
  module Cell
    ##
    # A blank cell will be ignored by the view.
    # Useful where a preceding cell spans more than one row.
    class Blank
      include Table::Cell::Base

      ##
      # A blank cell will always be blank.
      def blank?
        true
      end

      ##
      # Saves any errors where somebody forgets
      # to ignore blanks.
      # will always be empty
      def to_html(tag = :td)
        nil
      end

    end
  end
end