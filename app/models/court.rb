class Court < ActiveRecord::Base
  
  has_many :opening_times, :class_name => 'OpeningTime', :dependent => :destroy
  has_many :peak_times, :class_name => 'PeakTime', :dependent => :destroy
  
  validates_presence_of :number
  
  def open?(day, time)
    opening_times.where("day = :day AND :time BETWEEN 'court_times'.'from' AND 'court_times'.'to'", {day: day, time: time}).count > 0
  end

  def peak_time?(day, time)
    !peak_times.where("day = :day AND :time BETWEEN 'court_times'.'from' AND 'court_times'.'to'", {day: day, time: time}).empty?
  end
  
  class << self
  
    def peak_time?(court_number, day, time)
      court = Court.find_by(number: court_number)
      return false if court.nil?
      court.peak_time?(day, time)
    end
  end
  
end
