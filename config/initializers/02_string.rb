class String

  def to_type
    case self

    when /^\d+$/
      self.to_i
    when /^\d{2}:\d{2}$/
      Time.parse(self)
    else
      self
    end
  end

  #
  # TODO: These methods need to be moved into a module.
  # They don't belong here.
  #
  def valid_time?
    !(self =~ /([01][0-9]|2[0-3]):[0-5][0-9]/).nil?
  end

  def in_the_future?
    Time.parse(self).to_sec > DateTime.now.to_sec if self.valid_time?
  end

  def time_step(step)
    (Time.zone.parse(self) + step.minutes).to_s(:hrs_and_mins)
  end

   def time_step_back(step)
    (Time.zone.parse(self) - step.minutes).to_s(:hrs_and_mins)
  end

end