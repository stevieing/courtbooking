##
# Check whether an attribute is a DateTime in the past.
# This is achieved by converting it to seconds.
class TimePastValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if DateTime.parse(value).to_sec <= DateTime.now.to_sec
      record.errors[attribute] << (options[:message] || "is in the past")
    end
  end
end