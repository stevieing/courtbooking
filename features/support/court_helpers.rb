module CourtHelpers
  
  def create_courts(number)
   create_list(court_opening_type, number)
  end
  
  def setup_courts
    create_courts 4
  end

  def within_the_bookingslots_container(&block)
    within('#bookingslots', &block)
  end

  def within_the_calendar_container(&block)
    within('#calendar', &block)
  end
  
  def valid_time_and_place_text(booking)
    "Court: " + courts.first.number.to_s + " " + booking.time_and_place_text
  end

  def valid_closure_details
    r = Random.new.rand(0..(((slots.all.count)/2).round))
    create_closure_details({:description => "for maintenance", :date_from => dates.current_date_to_s, :time_from => slots.all[r], :time_to => slots.all[slots.all.count-5]})
    closure_details
  end

  def create_valid_closure(courts, details)
    if courts == :all
      ids = Court.pluck(:id)
    end
    create(:closure, details.merge(:court_ids => ids, :date_to => nil))
  end
end

World(CourtHelpers)