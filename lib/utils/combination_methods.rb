module CombinationMethods

  #
  # A way of extracting all of the slots from a Relation
  # Assumption: that you would only try and extract slots
  # from an object which includes Slots::ActiveRecordSlot
  def slots
    collect { |relation| relation.slot }
  end

  def combine(attribute)
    collect { |relation| relation.send(attribute)}.reduce(:+) || String.new
  end

end