class DuplicateBookingsValidator < ActiveModel::Validator
  
  def validate(record)
  	unless record.playing_on.blank? || record.playing_from.blank? || record.court_number.nil?
    	if record.class.where(:court_number => record.court_number, :playing_on => record.playing_on, :playing_from => record.playing_from).length > 0
      		record.errors[:base] << (options[:message] || "A booking already exists for #{record.playing_on.to_s(:uk)} #{record.playing_from} on court #{record.court_number}")
    	end
	end
  end
end