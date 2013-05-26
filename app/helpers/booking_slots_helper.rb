#TODO: REFACTOR - separation of responsibilities.
module BookingSlotsHelper
  def booking_slots(current_date, courts, timeslots, &block)
    BookingSlots.new(self, current_date, courts, timeslots, block).section
  end
  
  class BookingSlots < Struct.new(:view, :current_date, :courts, :timeslots, :callback)
    
    delegate :content_tag, to: :view
    
    def section
      content_tag :section, id: "bookingslots" do
        content_tag :table do
          courts_row + booking_slots_rows + courts_row
        end
      end
    end
    
    def courts_row
      content_tag :tr do
        space_tag + courts_header + space_tag
      end
    end
    
    def booking_slots_rows
      timeslots.slots.map do |slot|
        content_tag :tr do
          time_slot_cell(slot) + courts_cells(slot) +  time_slot_cell(slot)
        end
      end.join.html_safe
    end
    
    def time_slot_cell(slot)
      content_tag :td, slot_to_s(slot).html_safe
    end
    
    def slot_to_s(slot)
      slot.strftime("%H:%M")
    end
    
    def date_to_s(date)
      date.strftime('%d %B %Y')
    end
    
    def date_time_to_s(slot)
      date_to_s(current_date) + " " + slot_to_s(slot)
    end

    def courts_cells(slot)
      courts.map do |court| 
        content_tag :td, view.capture(court.number, date_time_to_s(slot), &callback)
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