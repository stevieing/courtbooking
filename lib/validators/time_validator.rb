##
# Check whether an attribute is a valid time in the format hh:mm
class TimeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.nil?
      unless value.valid_time?
          record.errors[attribute] << (options[:message] || "should be in format hh:mm")
      end
    end
  end
end