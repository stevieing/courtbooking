module CourtHelpers

  def create_courts(number)
   create_list(court_opening_type, number)
  end

  def setup_courts
    create_courts 4
    stub_settings
  end

  def within_the_bookingslots_container(&block)
    within('#booking-slots', &block)
  end

  def within_the_calendar_container(&block)
    within('#calendar', &block)
  end

  def valid_closure_details(n=0)
    from = booking_slots.all[2].from
    to = booking_slots.all[booking_slots.count-2].from
    create_closure_details({description: "for maintenance", date_from: current_date, date_to: current_date+n, time_from: from, time_to: to})
    closure_details
  end

  def create_valid_closure(courts, details)
    if courts == :all
      ids = Court.pluck(:id)
    end
    create(:closure, details.merge(court_ids: ids))
  end

  def create_activity_slot(closure_details)
    build(:activity_slot, from: closure_details[:time_from], to: closure_details[:time_to], constraints: booking_slots.constraints)
  end

  def set_dates(date, time)
    stub_dates(date, time)
    create_current_date(Date.today)
    #create_dates(Calendar.new(date_from: Date.today, current_date: Date.today, no_of_days: 21))
  end
end

World(CourtHelpers)