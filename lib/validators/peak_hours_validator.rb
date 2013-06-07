class PeakHoursValidator < ActiveModel::Validator
  
  def validate(record)
    set_options
    unless record.playing_on.saturday? || record.playing_on.sunday?
      if peak_hours?(record.playing_from)
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
    :playing_on => (record.playing_on.beginning_of_week..record.playing_on.beginning_of_week+5))
  end
  
  def find_peak_hours_records(records)
    records.select do |r| 
      peak_hours? r.playing_from
    end
  end
  
  def peak_hours?(playing_from)
    Time.parse(playing_from).to_sec >= @peak_hours_start_time.to_sec &&
    Time.parse(playing_from).to_sec <= @peak_hours_finish_time.to_sec
  end

end