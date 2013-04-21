module CalendarHelper
  def calendar(days, date = Date.today, &block)
    Calendar.new(self, date, days, block).table
  end
  
  class Calendar < Struct.new(:view, :date, :days, :callback)
    
    delegate :content_tag, to: :view
    
    def table
      content_tag :table, class: "calendar" do
        table_header + day_of_week_rows + day_rows
      end
    end
    
    def day_of_week_rows
      content_tag :tr do
        days_to_dates.map { |date| content_tag :td, date.strftime('%a')}.join.html_safe
      end
    end
    
    def day_rows
      content_tag :tr do
        days_to_dates.map { |date| content_tag :td, view.capture(date, date.strftime('%d'), &callback)}.join.html_safe
      end
    end
    
    def days_to_dates
      (date..date+(days-1)).collect.to_a
    end
    
    def table_header
      content_tag :caption, month_and_year.html_safe
    end
    
    def month_and_year
      last_day = date+(days-1)
      month = (date.month == last_day.month ? date.strftime("%B") : "#{date.strftime("%B")} -> #{last_day.strftime("%B")}")
      month + " " + last_day.year.to_s
    end
  end
end