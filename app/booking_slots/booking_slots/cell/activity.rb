module BookingSlots
  module Cell
    class Activity
      include Record

      def text
        @text ||= @activity.description
      end

      def span
        @span ||= @activity.slot.between
      end

      def klass
        @klass ||= @activity.class.to_s.downcase
      end

    private

      def build_record(record, user)
        @activity = record
      end

    end
  end
end