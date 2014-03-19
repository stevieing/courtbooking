class Closure < Activity

  validates_presence_of :date_to
  validates_date :date_to, on_or_after: lambda {:date_from}

  scope :by_day,    lambda{|day| where(":day BETWEEN date_from AND date_to", {day: day})}

  def message
    "Courts #{self.courts.pluck(:number).join(',')} closed from #{self.time_from} to #{self.time_to} for #{self.description}. "
  end
end