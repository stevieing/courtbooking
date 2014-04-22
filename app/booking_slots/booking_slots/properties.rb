module BookingSlots
  class Properties
    attr_reader :user, :date
    delegate :wday, to: :date

    def initialize(date, user)
      @date, @user = date, user
    end

    def valid?
      @date.kind_of?(Date)
    end

    def inspect
      "<#{self.class}: @date=#{@date}, @user=#{@user}, @permissions=#{@permissions.inspect}>"
    end
  end
end