module BookingSlots
  module Cell
    class Activity < Base

      def self.build(*args)
        new(args.first)
      end

      def initialize(activity)
        @activity = activity
      end

      def text
        @text ||= @activity.description
      end

      def span
        @span ||= @activity.slot.between
      end

      def klass
        @klass ||= @activity.class.to_s.downcase
      end

      def active?
        true
      end
    end
  end
end