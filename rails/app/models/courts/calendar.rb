module Courts

  #
  # = Courts::Calendar
  #
  #  This builds a calendar for the courts page.
  #  It allows the user to move to the courts page for
  #  another day.
  #
  class Calendar

    include ActiveModel::Serializers::JSON

    include HashAttributes
    hash_attributes :date_from, :current_date, :no_of_days, :split
    attr_reader :table, :dates
    delegate :heading, :find, :rows, to: :table

    def initialize(attributes)
      set_attributes(attributes)
      @table = create_table
    end

    def dates
      @dates ||= date_from.to(no_of_days)
    end

    def valid?
      @dates && @table
    end

    def html_class
      "calendar"
    end

    def as_json options={}
     {
       table: @table
     }
    end

  private

    def default_attributes #:nodoc
      { date_from: Date.today, split: 7}
    end

    def create_table #:nodoc
      Table::Base.new do |t|
        t.heading = date_from.calendar_header(date_from+no_of_days)
        t.add :header, header_row
        dates.in_groups_of(split, false).each_with_index do |group, index|
          t.add index.to_s, new_row(group)
        end
      end
    end

    def header_row #:nodoc
      Table::Row.new(header: true) do |row|
        date_from.days_of_week(split-1).each do |day|
          row.add day, Table::Cell::Text.new(text: day, header: true)
        end
      end
    end

    def new_row(group) #:nodoc
      Table::Row.new do |row|
        group.each do |date|
          row.add date, Table::Cell::CalendarDate.new(date, current_date)
        end
      end
    end

  end
end