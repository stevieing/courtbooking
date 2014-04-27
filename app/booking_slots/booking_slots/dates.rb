module BookingSlots
  class Dates

    include Rails.application.routes.url_helpers
    include IndexManager
    include HashAttributes

    set_enumerator :dates
    attr_reader :dates
    hash_attributes :date_from, :current_date, :no_of_days, :split


    def initialize(attributes)
      set_attributes(attributes)
      @dates = set_dates
    end

    def header
      @date_from.days_of_week(@split - 1)
    end

    def current_date_to_s
      @current_date.to_s(:uk)
    end

    def current_record
      current
    end

    def valid?
      @dates.any?
    end

    alias_method :all, :dates

    def default_attributes
      { date_from: Date.today, split: 7}
    end

  private

    def set_dates
      @date_from.to(@no_of_days)
    end

  end
end