##
# Check whether two nominated times are after each other
class TimeAfterTimeValidator < ActiveModel::Validator

  ##
  # from will be set to time_from
  # to will be set to time_to
  def default_options
    {from: :time_from, to: :time_to}
  end

  ##
  # Check whether to is after from.
  # Both will be converted to DateTime in seconds.
  # options can be passed with relate to the attributes
  # for from and to.
  # These will be defaulted to time_from and time_to.
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