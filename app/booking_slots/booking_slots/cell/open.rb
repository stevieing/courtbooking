module BookingSlots
  module Cell
    class Open
      def self.build(table)
        BookingSlots::Cell.cell_type_for(table)
      end
    end
  end
end