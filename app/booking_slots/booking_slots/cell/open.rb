module BookingSlots
  module Cell
    class Open
      def self.build(table)
        record = table.current_record
        "BookingSlots::Cell::#{get_klass(record)}".constantize.build(record, table.user)
      end

    private

      def self.get_klass(record)
        record.class.superclass == ActiveRecord::Base ? record.class : record.class.superclass
      end
    end
  end
end