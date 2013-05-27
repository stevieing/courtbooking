class ChangedValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    if record.send("#{attribute}_changed?".to_sym)
      record.errors[attribute] << (options[:message] || "cannot be changed") 
    end
  end
end