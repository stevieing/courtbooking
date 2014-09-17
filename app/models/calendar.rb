class Calendar

  include HashAttributes
  hash_attributes :date_from, :current_date, :no_of_days, :split
  attr_reader :rows, :dates

  def initialize(attributes)
    set_attributes(attributes)
    @rows = create_rows
  end

  def heading
    @heading ||= current_date.calendar_header(current_date+no_of_days)
  end

  def dates
    @dates ||= date_from.to(no_of_days)
  end

private

  def default_attributes
    { date_from: Date.today, split: 7}
  end

  def create_rows
    {}.tap do |rows|
      rows[:header] = header_row
      dates.in_groups_of(split, false).each_with_index do |group, index|
        rows[index.to_s] = new_row(group)
      end
    end
  end

  def header_row
    Slots::Row.new do |row|
      @date_from.days_of_week(split-1).each do |day|
        row.add day, Slots::Cell::Text.new(day)
      end
    end
  end

  def new_row(group)
    Slots::Row.new do |row|
      group.each do |date|
        cell = Slots::Cell::CalendarDate.new(date, current_date)
        row.add cell.text, cell
      end
    end
  end

end