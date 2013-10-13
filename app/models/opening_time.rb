class OpeningTime < CourtTime
  
  attr_writer :slots
  
  after_save :create_slots
  
  def slots
    @slots ||= create_slots
  end
  
  private
  
  def create_slots
    @slots = Slots.new(self.from, self.to).value
  end
end