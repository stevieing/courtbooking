class CourtTime < ActiveRecord::Base
  
  belongs_to :court
  
  validates_presence_of :time_from, :time_to, :day
  validates :time_from, :time_to, time: true
  validates_with TimeAfterTimeValidator

end