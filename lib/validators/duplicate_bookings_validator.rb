class DuplicateBookingsValidator < ActiveModel::Validator

  def validate(record)
  	unless record.date_from.blank? || record.time_from.blank? || record.court_number.nil?
    	if record.class.where(court_number: record.court_number, date_from: record.date_from, time_from: record.time_from).length > 0
      		record.errors[:base] << (options[:message] || "A booking already exists for #{record.date_from.to_s(:uk)} #{record.time_from} on court #{record.court_number}")
    	end
		end
  end
end