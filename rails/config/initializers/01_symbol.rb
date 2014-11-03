class Symbol
  def to_day
    self.to_s.capitalize
  end
  
  def remove_underscores
    self.to_s.gsub(/_/,'')
  end
  
  def to_heading
    self.to_s.titleize
  end

  def to_class_name
    self.to_heading.gsub(' ','')
  end
  
  def superclass
    self.to_s.classify.constantize.superclass
  end
end