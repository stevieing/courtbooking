module BookingSlots
  module Cell
    module Record
      extend ActiveSupport::Concern
      include Base

      included do
      end

      def active?
        true
      end
    end
  end
end