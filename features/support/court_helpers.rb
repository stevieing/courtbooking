module CourtHelpers
  def days_or_weeks(arg1, arg2)
    days = arg1.to_i
    arg2.eql?("weeks") ? days*7 : days
  end
end

World(CourtHelpers)