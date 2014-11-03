class TimeAfterTimeValidator < ActiveModel::Validator

  def default_options
    {from: :time_from, to: :time_to}
  end
  
  def validate(record)
    _options = default_options.merge(options)
    from, to = record.send(_options[:from]), record.send(_options[:to])
    unless from.nil? || to.nil?
      if from.valid_time? && to.valid_time?
        if DateTime.parse(to).to_sec <= DateTime.parse(from).to_sec
          record.errors[:base] << (options[:message] || "#{_options[:to].to_heading} must be after #{_options[:from].to_heading}")
        end
      end
    end
  end
end