class Court < ActiveRecord::Base
  
  has_many :opening_times, :class_name => 'OpeningTime', :dependent => :destroy
  has_many :peak_times, :class_name => 'PeakTime', :dependent => :destroy
  has_many :occurrences
  has_many :closures, through: :occurrences

  validates :number, :presence => true, :uniqueness => true

  delegate :open?, to: :opening_times
  delegate :peak_time?, to: :peak_times
 
  class << self
  
    def peak_time?(court_number, day, time)
      court = Court.find_by(number: court_number)
      return false if court.nil?
      court.peak_time?(day, time)
    end
    
    def next_court_number
      count == 0 ? 1 : maximum(:number)+1
    end
  end
  
end
