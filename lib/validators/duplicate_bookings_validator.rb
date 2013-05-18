class DuplicateBookingsValidator < ActiveModel::Validator
  
  def validate(record)
    if record.class.where(:court_number => record.court_number, :booking_date_and_time => record.booking_date_and_time).length > 0
      record.errors[:base] << (options[:message] || "A booking already exists for #{record.booking_date_and_time.strftime("%d %B %Y %H:%M")} on court #{record.court_number}")
    end
  end
  
end