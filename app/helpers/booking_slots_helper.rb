#TODO: might need to move this into a separate class due to increasing complexity and name variable clashes.
module BookingSlotsHelper
  def booking_slots(current_date, courts, slots, &block)
    BookingSlots.new(self, current_date, courts, slots, block).section
  end
  
  class BookingSlots < Struct.new(:view, :current_date, :courts, :todays_slots, :callback)
    
    delegate :content_tag, to: :view

    def initialize(*args)
      super(*args)
    end
    
    def section
      content_tag :section, id: "bookingslots" do
        content_tag :table do
          header + courts_row + booking_slots_rows + courts_row
        end
      end
    end
    
    def header
      content_tag :caption do
        current_date.to_s(:uk).html_safe
      end
    end
    
    def courts_row
      content_tag :tr do
        space_tag + courts_header + space_tag
      end
    end
    
    def booking_slots_rows
      String.new.tap do |row|
        until (todays_slots.current.nil?)
          row << content_tag(:tr, slot_cell + courts_cells +  slot_cell)
          todays_slots.up
        end
      end.html_safe
    end
    
    def slot_cell
      content_tag :td, todays_slots.current.from.html_safe
    end

    def courts_cells
      courts.map do |court|
        content_tag :td, view.capture(court, todays_slots, &callback)
      end.join.html_safe
    end

    def space_tag
      content_tag :th, "&nbsp;".html_safe
    end
    
    def courts_header
      courts.map { |court| content_tag :th, "Court " + court.number.to_s }.join.html_safe
    end
   
  end
end