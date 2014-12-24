module Table

  module Cell

    ###
    # a shared set of attributes and methods necessary for each type of cell:
    # * +text+: the text that will be out output. This could be anything from a space to link text.
    # * +link+: This will usually be a link to a booking.
    # * +htmL_class+: This could be the type of cell to allow different colouring for a type of event.
    module Base

      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include Slots::Helpers

      def self.included(base)
        base.include(ActiveModel::Serializers::JSON)
      end

      ##
      # This will be the text that is output in the view
      # If the cell is a link it will be the link text
      attr_accessor :text

      ##
      # A link to a defined resource and record
      attr_accessor :link

      ##
      # The html class to be output to the view
      attr_accessor :html_class

      ##
      # synonymouse with the rowspan in the view
      attr_accessor :span

      ##
      # Needed to construct a content_tag
      attr_accessor :output_buffer

      #
      # If a link is present then we would need to construct a link_to
      def link?
        link.present?
      end

      #
      # If a cell is closed it still needs to be presented.
      def closed?
        false
      end

      #
      # If a cell is blank then it needs to be ignored.
      def blank?
        false
      end

      #
      # If a cell is a remote link
      def remote
        false
      end

      #
      # If a cell is empty it is ripe for filling
      def empty?
        false
      end

      #
      # some cells such as closures need to span several slots.
      # This will make use of the rowspan attribute.
      def span
        @span ||= 1
      end

      def header?
        false
      end

      ##
      # The class in which module is included.
      # Example:
      #  cell = Table::Cell::Booking
      #  cell.type => :booking
      def type
        self.class_to_sym
      end

      ##
      # It will output the main attributes
      def inspect
        "<#{self.class}: @text=\"#{@text}\", @link=#{@link}, @html_class=#{@html_class}, @span=#{@span}>"
      end

      ##
      # Convert the cell to a html tag.
      # The default tag is td.
      # If the cell is a link then turn the cell into a link using text, link and remote attributes
      # Otherwise output the cell text.
      def to_html(tag = :td)
        content_tag tag, class: html_class, rowspan: span do
          link? ? link_to(text, link, remote: remote) : text
        end
      end

      def attributes
        {
          text: text,
          link: link,
          html_class: html_class,
          span: span,
          type: type
        }
      end

    end
  end
end