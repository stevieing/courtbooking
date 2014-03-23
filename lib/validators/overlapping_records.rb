class OverlappingRecords

  class QueryParameters

    attr_reader :date_from, :date_to, :time_from, :time_to, :court_ids

    def initialize(object)
      @date_from    = object.date_from
      @date_to      = object.is_a?(Closure) ? object.date_to : object.date_from
      @time_from    = object.time_from
      @time_to      = object.time_to
      @court_ids    = object.respond_to?(:court_ids) ? object.court_ids : Array(object.court_id)
    end

    def valid?
      @date_from.is_a?(Date) && @date_to.is_a?(Date) &&
      @time_from.present? && @time_to.present? &&
      @court_ids.present?
    end

    def time_hash
      {time_from: @time_from, time_to: @time_to}
    end

    def time_string
      '(:time_from >= time_from and :time_from < time_to) OR (:time_to > time_from and :time_to <= time_to)'
    end

    def date_hash
       {date_from: @date_from, date_to: @date_to}
    end

    def date_string
      '(date_from BETWEEN :date_from AND :date_to OR date_to BETWEEN :date_from AND :date_to)'
    end

    def date_range
      @date_from..@date_to
    end
  end

  include Enumerable
  attr_reader :parameters, :records

  delegate :valid?, to: :parameters
  delegate :empty?, to: :records

  def initialize(object)
    @object = object
    @parameters = QueryParameters.new(@object)
    @records = get_records
  end

  def each(&block)
    @records.each(&block)
  end

  def get_records
    @parameters.valid? ? find_records : @object.class.none
  end

  def find_records
    find_bookings+find_activities
  end

  def find_bookings
    Booking
    .where(date_from: (parameters.date_range), court_id: parameters.court_ids)
    .where(parameters.time_string, parameters.time_hash)
  end

  def find_activities
    Activity.joins(:courts).where(courts: {id: parameters.court_ids})
    .where(parameters.date_string, parameters.date_hash)
    .where(parameters.time_string, parameters.time_hash)
  end
end