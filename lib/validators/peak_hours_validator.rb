class PeakHoursValidator < ActiveModel::Validator
  
  def validate(record)
    max_bookings = Rails.configuration.max_peak_hours_bookings
    if Court.peak_time?(record.court_number, record.playing_on.wday, record.playing_from)
      if find_peak_hours_records(user_records(record)).length >= max_bookings
        record.errors[:base] << (options[:message] || "No more than #{max_bookings} bookings are allowed during peak hours in the same week.")
      end
    end
  end
  
  private
  
  def user_records(record)
    record.class.where(:user_id => record.user_id, 
    :playing_on => (record.playing_on.beginning_of_week..record.playing_on.end_of_week))
  end
  
  def find_peak_hours_records(records)
    records.select do |r| 
      Court.peak_time?(r.court_number, r.playing_on.wday, r.playing_from)
    end
  end

end