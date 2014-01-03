class String
  def hhmm_to_t
    Time.parse(self)
  end
  
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

end