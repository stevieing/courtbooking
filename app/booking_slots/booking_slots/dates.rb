module BookingSlots
  class Dates

    include Rails.application.routes.url_helpers
    include IndexManager

    set_enumerator :dates
    attr_reader :dates, :date_from, :current_date, :no_of_days, :split

    def initialize(date_from, current_date, no_of_days, split = 7)
      @date_from, @current_date, @no_of_days, @split = date_from, current_date, no_of_days, split
      @dates = set_dates
    end

    def header
      @date_from.days_of_week(@split - 1)
    end

    ##
    # purely for testing purposes so I can remove all of that extra code.
    #
    #
    def current_date_to_s
      @current_date.to_s(:uk)
    end

    def current_record
      BookingSlots::CurrentRecord.create(current) do |record|
        record.text = current.day_of_month
        if current == @current_date
          record.klass  = "selected"
        else
          record.link   = courts_path(current.to_s)
        end
      end
    end

    def valid?
      !@dates.empty?
    end

    alias_method :all, :dates

    private

    def set_dates
      @date_from.to(@no_of_days)
    end

  end
end