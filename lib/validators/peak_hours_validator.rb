class PeakHoursValidator < ActiveModel::Validator
  
  def validate(record)
    set_options
    unless record.booking_date_and_time.to_date.saturday? || record.booking_date_and_time.to_date.sunday?
      if peak_hours?(record.booking_date_and_time)
        if find_peak_hours_records(find_weekday_records(record)).length >= @max_peak_hours_bookings
          record.errors[:base] << (options[:message] || "No more than #{@max_peak_hours_bookings} bookings are allowed during peak hours in the same week.")
        end
      end
    end
  end
  
  private
  
  def set_options
    options.each do |key, value|
      instance_variable_set("@#{key}",(value.is_a?(Proc) ? value.call : value))
    end
  end
  
  def find_weekday_records(record)
    record.class.where(:user_id => record.user_id, 
    :booking_date_and_time => (record.booking_date_and_time.to_date.beginning_of_week..record.booking_date_and_time.to_date.beginning_of_week+5))
  end
  
  def find_peak_hours_records(records)
    records.select do |r| 
      peak_hours? r.booking_date_and_time
    end
  end
  
  def peak_hours?(date_and_time)
    date_and_time.to_sec >= @peak_hours_start_time.to_sec &&
    date_and_time.to_sec <= @peak_hours_finish_time.to_sec
  end

end