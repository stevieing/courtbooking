module DateTimeHelpers
  
  class Utils
    
    attr_accessor :current_date
    
    def initialize(date, time)
      set_system_date(date)
      set_system_datetime(date, time)
      @current_date = Date.today
    end
    
    def current_date_to_s
      @current_date.to_s(:uk)
    end
    
    def set_current_date(n)
      @current_date += n
    end
    
    def end_of_month
      set_system_date(@current_date.end_of_month)
      @current_date = Date.today
    end
    
    def valid_playing_on
      set_date(1)
    end
    
    def in_the_past(n)
      set_date(-n)
    end
    
    def in_the_future(n)
      set_date(n)
    end
    
    def bookings_in_the_past(date)
      set_system_datetime(date)
    end
    
    private
    
    def set_date(i)
      "#{(@current_date + i).to_s(:uk)}"
    end
    
    def set_system_date(date)
      date = Date.parse(date) if date.is_a? (String)
      Date.stub(:today).and_return(date)
    end

    def set_system_datetime(date, time = nil)
      if time.nil?
        datetime(date)
      else
        datetime(date + " " + time)
      end
    end
    
    def datetime(datetime)
      DateTime.stub(:now).and_return(DateTime.parse(datetime))
    end
  end
  
  def set_dates(date, time)
    @dates = DateTimeHelpers::Utils.new(date, time)
  end
  
end

World(DateTimeHelpers)