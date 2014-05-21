module BookingSlots
  module Cell
    module Base

      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods
        def build(*args)
          new(*args)
        end
      end

      attr_accessor :text, :link, :klass, :span

      def link?
        link.present?
      end

      def valid?
        true
      end

      def active?
        false
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
        "<#{self.class}: @text=\"#{@text}\", @link=#{@link}, @class=#{@klass}, @span=#{@span}>"
      end
    end
  end
end