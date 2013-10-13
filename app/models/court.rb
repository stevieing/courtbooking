class Court < ActiveRecord::Base
  
  has_many :opening_times, :class_name => 'OpeningTime', :dependent => :destroy
  has_many :peak_times, :class_name => 'PeakTime', :dependent => :destroy
  
  validates_presence_of :number
  
  def open?(day, time)
    self.opening_times.where(:day => day).collect { |r| r.slots }.flatten.include?(time)
  end
  
  def closed?(day, time)
    !open?(day, time)
  end
  
  def peak_time?(day, time)
    times = self.peak_times.where(:day => day).first
    return false if times.nil?
    Time.parse(time).to_sec >= Time.parse(times.from).to_sec && Time.parse(time).to_sec <= Time.parse(times.to).to_sec
  end
  
  class << self
    def open?(day, time)
      Court.all.collect {|c| c.open?(day, time)}.any?
    end
    
    def closed?(day, time)
      Court.all.collect {|c| c.closed?(day, time)}.all?
    end
    
    def peak_time?(court_number, day, time)
      court = Court.find_by(number: court_number)
      return false if court.nil?
      court.peak_time?(day, time)
    end
  end
  
end
