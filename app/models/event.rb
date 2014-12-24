class Event < Activity

  scope :by_day,    lambda{|day| includes(:courts).where(date_from: day) }

  before_save do
    self.date_to = self.date_from
    true
  end

  def date_to
    @date_to || self.date_from
  end

end