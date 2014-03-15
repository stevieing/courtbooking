module BookingSlots
  class Properties
    attr_reader :user, :date
    delegate :wday, to: :date

    def initialize(date, user)
      @date, @user = date, user
      @permissions = Permissions.permission_for(@user)
    end

    def edit_booking?(booking)
      @permissions.allow?(:bookings, :edit, booking)
    end

    def valid?
      @date.kind_of?(Date)
    end

    def inspect
      "<#{self.class}: @date=#{@date}, @user=#{@user}, @permissions=#{@permissions.inspect}>"
    end
  end
end