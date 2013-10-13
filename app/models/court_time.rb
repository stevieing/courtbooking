class CourtTime < ActiveRecord::Base
  
  belongs_to :court
  
  validates_presence_of :from, :to, :day
  validates :from, :to, :time => true
  
end