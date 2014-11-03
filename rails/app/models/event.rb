class Event < Activity

  scope :by_day,    lambda{|day| includes(:courts).where(date_from: day) }

end