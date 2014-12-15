module Courts

  #
  #
  #  This builds a calendar for the courts page.
  #  It allows the user to move to the courts page for
  #  another day.
  class Calendar

    class Header

      attr_reader :id
      alias_attribute :heading, :id

      def self.build(date, split)
        [].tap do |header|
          (date..date+(split-1)).each do |d|
            header << new(d.strftime('%a'))
          end
        end
      end

      def initialize(day)
        @id = day
      end
    end

    include HashAttributes
    hash_attributes date_from: Date.today, current_date: Date.today, no_of_days: 1, split: 7
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

  private

    def create_table
      Table::Base.new do |t|
        t.heading = date_from.calendar_header(date_from+no_of_days)
        dates.in_groups_of(split, false).each_with_index do |group, index|
          t.add index.to_s, new_row(group)
        end
      end.top(header_row)
    end

    def header_row
      Table::Row.build_header(Header.build(date_from, split))
    end

    def new_row(group)
      Table::Row.new do |row|
        group.each do |date|
          row.add date, Table::Cell::Date.new(date, current_date)
        end
      end
    end

  end
end