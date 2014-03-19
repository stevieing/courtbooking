module BookingSlotsTableHelpers

  def cell(x, y)
    subject.rows[x].cells[y]
  end
end