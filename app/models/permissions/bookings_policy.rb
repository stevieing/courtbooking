##
# TODO: need to remove user.nil? with a GuestUser.
#
#
module Permissions
  class BookingsPolicy
    def initialize(user)
      @user = user
      @permissions = Permissions.permission_for(@user)
      @allow_all = allow_all_bookings
    end

    def bookings
      return Booking.none if @user.nil?
      allow_all? ? Booking.includes(:user, :court).ordered.load : @user.bookings.includes(:court).ordered.load
    end

    def allow_all?
      @allow_all
    end

    def edit?(booking)
      editable? booking, :edit
    end

    def delete?(booking)
      editable? booking, :destroy
    end

    def params(params)
      params.permit(ACCEPTED_ATTRIBUTES.booking)
    end

    def allow_all_bookings
      return false if @user.nil?
      @user.admin? || @user.allowed_actions.find_by(name: "Edit all bookings")
    end

  private

    def editable?(booking, action)
      booking.in_the_future? && (allow_all? || @permissions.allow?(:bookings, action, booking))
    end

  end
end