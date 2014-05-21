module BookingSlots
  module Cell

    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Blank
    autoload :Text
    autoload :Closed
    autoload :Open
    autoload :Booking
    autoload :Activity


    class << self

      def build(*args)
        cell_type_for(*args)
      end

      def cell_type_for(*args)
        return if args.first.nil?
        return cell_type_for_record(*args) if args.first.is_a?(BookingSlots::BookingsGrid)
        return BookingSlots::Cell::CalendarDate.build(*args) if args.first.is_a?(Date)
        return "BookingSlots::Cell::#{args.first.to_s.classify}".constantize.build(args.last) if args.first.is_a?(Symbol)
      end

    private

      def cell_type_for_record(table)
        record = table.current_record
        "BookingSlots::Cell::#{get_klass(record)}".constantize.build(record, table)
      end

      def get_klass(record)
        record.class.superclass == ActiveRecord::Base ? record.class : record.class.superclass
      end

    end
  end
end