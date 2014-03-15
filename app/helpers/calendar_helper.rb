#
# TODO: This should be moved into the booking slots module.
#
#

module CalendarHelper
  def calendar(days, current_date, start_date = Date.today, &block)
    Calendar.new(self, start_date, current_date, days, block).section
  end
  
  class Calendar < Struct.new(:view, :start_date, :current_date, :days, :callback)
    
    delegate :content_tag, to: :view
    
    def section
      dates = start_date.to(days)
      content_tag :section, id: "calendar" do
        content_tag :table do
          header(dates.first.calendar_header(dates.last)) + days_header + week_rows(dates.in_groups_of(7))
        end
      end
    end

    def header(text)
      content_tag :caption do
        text.html_safe
      end
    end
    
    def days_header
      content_tag :tr do
        start_date.days_of_week(6).map do |day|
          content_tag :th, day
        end.join.html_safe
      end
    end
    
    def week_rows(weeks)
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end
    
    def day_cell(day)
      content_tag :td, view.capture(day, day.day_of_month.html_safe, &callback), class: (day == current_date ? "selected" : "") unless day.nil?
    end

  end
end