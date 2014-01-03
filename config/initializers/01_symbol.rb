class Symbol
  def to_day
    self.to_s.capitalize
  end
  
  def remove_underscores
    self.to_s.gsub(/_/,'')
  end
  
  def to_heading
    self.to_s.gsub(/_/,' ').titleize
  end
end