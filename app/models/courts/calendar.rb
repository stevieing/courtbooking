module Courts

  ##
  # This builds a calendar for the courts page.
  # It allows the user to move to the courts page for
  # another day.
  class Calendar

    ##
    # This is a temporary solution.
    # It is an internal class which allows a header row to
    # be created using the corresponding class method in Table.
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

    include ActiveModel::Serializers::JSON
    include HashAttributes
    hash_attributes date_from: Date.today, current_date: Date.today, no_of_days: 1, split: 7
    attr_reader :table, :dates
    delegate :heading, :find, :rows, to: :table

    ##
    # Add all of the instance variables and create a Table.
    # Example:
    #   Calendar.new(#16-12-14#, 1#9-12-14#, 10, 5)
    #
    # Will produce a two row table of Date cells.
    # With a header row which contains the three character day.
    def initialize(attributes)
      set_attributes(attributes)
      @table = create_table
    end

    ##
    # Creates an array of dates using the date_from and no_of_days.
    # Example:
    #  date_from: 16-12-14, no_of_days: 5 =>
    #  [#16-12-14#, #17-12-14#, #18-12-14#, #19-12-14#, #20-12-14#]
    def dates
      @dates ||= date_from.to(no_of_days)
    end

    ##
    # A calendar will be valid if the dates
    # and table exist.
    def valid?
      @dates && @table
    end

    ##
    # "calendar", For use in view.
    def html_class
      "calendar"
    end

    ##
    # Creates a root element Calendar and delegates
    # to the table.
    def as_json(options = {})
      {
        calendar:
        {
          table: table
        }
      }
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