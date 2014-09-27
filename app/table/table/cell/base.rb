module Table
  #
  # = Table::Cell::Base
  #
  # a shared set of attributes and methods necessary for each type of cell:
  #  * text: the text that will be out output. This could be anything from a space to link text.
  #  * link: This will usually be a link to a booking.
  #  * htmL_class: This could be the type of cell to allow different colouring for a type of event.
  #
  module Cell
    module Base

      attr_accessor :text, :link, :html_class, :span

      #
      # If a link is present then we would need to construct a link_to
      #
      def link?
        link.present?
      end

      #
      # If a cell is closed it still needs to be presented.
      #
      def closed?
        false
      end

      #
      # If a cell is blank then it needs to be ignored.
      #
      def blank?
        false
      end

      #
      # some cells such as closures need to span several slots.
      # This will make use of the rowspan attribute.
      #
      def span
        @span ||= 1
      end

      def inspect
        "<#{self.class}: @text=\"#{@text}\", @link=#{@link}, @html_class=#{@html_class}, @span=#{@span}>"
      end
    end
  end
end