class DuplicateBookingsValidator < ActiveModel::Validator
  
  def validate(record)
    if record.class.where(:court_number => record.court_number, :playing_at => record.playing_at).length > 0
      record.errors[:base] << (options[:message] || "A booking already exists for #{record.playing_at.strftime("%d %B %Y %H:%M")} on court #{record.court_number}")
    end
  end
  
end