class TimeValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    unless value =~ /([01][0-9]|2[0-3]):[0-5][0-9]/
      record.errors[attribute] << (options[:message] || "should be in format hh:mm")
    end
  end
end