module BookingSlots
  module Cell
    class Activity
      include Record

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

    end
  end
end