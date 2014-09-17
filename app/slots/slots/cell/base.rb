module Slots
  module Cell
    module Base

      attr_accessor :text, :link, :html_class, :span

      def link?
        link.present?
      end

      def closed?
        false
      end

      def blank?
        false
      end

      def span
        @span ||= 1
      end

      def inspect
        "<#{self.class}: @text=\"#{@text}\", @link=#{@link}, @html_class=#{@html_class}, @span=#{@span}>"
      end
    end
  end
end