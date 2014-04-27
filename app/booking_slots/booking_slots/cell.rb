module BookingSlots
  module Cell

    def self.build(*args)
      return if args.first.nil?
      "BookingSlots::Cell::#{args.first.to_s.classify}".constantize.build(args.last)
    end

    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Blank
    autoload :Text
    autoload :Closed
    autoload :Open
    autoload :Booking
    autoload :Activity
  end
end