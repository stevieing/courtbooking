module BookingSlots
  module Cell
    module Record
      extend ActiveSupport::Concern
      include Base

      included do
      end

      module ClassMethods
        def build(record, table)
          new(record, table.user) do |cell|
            table.skip(cell.span)
          end
        end
      end

      def initialize(record, user, &block)
        build_record(record, user)
        yield self if block_given?
      end

      def active?
        true
      end
    end
  end
end