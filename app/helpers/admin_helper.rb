module AdminHelper
  
  def days_of_week(option)
    case option

    when :all
      {option.to_s => "06"}
    when :week
      {option.to_s => "04"}
    else
      Date.days_of_week
    end
  end
end
