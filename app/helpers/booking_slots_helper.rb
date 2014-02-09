module BookingSlotsHelper
  def booking_slots(current_date, courts, slots, &block)
    #need to duplicate slots as the bang operator is used.
    BookingSlots.new(self, current_date, courts, slots.dup, block).section
  end
  
  class BookingSlots < Struct.new(:view, :current_date, :courts, :slots, :callback)
    
    delegate :content_tag, to: :view
    
    def section
      content_tag :section, id: "bookingslots" do
        message + table
      end
    end

    def message
      content_tag :div, id: "message" do
        closures_for_all_courts.html_safe
      end
    end

    def table
      content_tag :table do
        header + courts_row + booking_slots_rows + courts_row
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
      slots.map do |slot|
        content_tag :tr do
          slot_cell(slot) + courts_cells(slot) +  slot_cell(slot)
        end
      end.join.html_safe
    end
    
    def slot_cell(slot)
      content_tag :td, slot.html_safe
    end

    def courts_cells(slot)
      courts.map do |court|
        content_tag :td, view.capture(new_booking(court.number,slot), &callback)
      end.join.html_safe
    end
    
    def space_tag
      content_tag :th, "&nbsp;".html_safe
    end
    
    def courts_header
      courts.map { |court| content_tag :th, "Court " + court.number.to_s }.join.html_safe
    end
  
    def new_booking(court_number, slot)
      Booking.new(court_number: court_number, playing_on: current_date.to_s(:uk), playing_from: slot, playing_to: slots.next(slot))
    end

    def closures_for_all_courts
      String.new.tap do |description|
        Court.closures_for_all_courts(current_date.to_datetime).each do |closure|
          slots.reject_range!(closure.time_from, closure.time_to)
          description << closure.message
        end
      end.html_safe
    end
   
  end
end