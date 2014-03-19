class Event < Activity

  scope :by_day,    lambda{|day| where(date_from: day) }

end