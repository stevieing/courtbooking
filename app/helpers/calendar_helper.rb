module CalendarHelper
  def calendar(days, current_date, start_date = Date.today, &block)
    Calendar.new(self, start_date, current_date, days, block).section
  end
  
  class Calendar < Struct.new(:view, :start_date, :current_date, :days, :callback)
    
    delegate :content_tag, to: :view
    
    def section
      @dates = dates
      content_tag :section, id: "calendar" do
        content_tag :table do
          header + days_header + week_rows
        end
      end
    end

    def header
      content_tag :caption do
        (@dates.first.month == @dates.last.month ? @dates.first.strftime('%B %Y') : "#{@dates.first.strftime('%B')} -> #{@dates.last.strftime('%B %Y')}").html_safe
      end
    end
    
    def days_header
      content_tag :tr do
        days_of_week.map do |day|
          content_tag :th, day.strftime('%a')
        end.join.html_safe
      end
    end
    
    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end
    
    def day_cell(day)
      content_tag :td, view.capture(day, day.strftime('%d').html_safe, &callback), class: (day == current_date ? "selected" : "")
    end
    
    def dates
      (start_date..start_date+(days-1)).collect.to_a
    end
    
    def weeks
      @dates.in_groups_of(7)
    end
    
    def days_of_week
      (start_date..start_date+(6)).collect.to_a
    end
 
  end
end