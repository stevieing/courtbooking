###
#
# A Member is a User who is a member of the club and who is signed in.
# Their permissions will be determined through a MemberPermissions object.
#
class Member < User

  include Permissions

  ##
  # If a Member has access to edit all bookings then all bookings will be returned.
  # otherwise only the bookings they have created will be returned.
  # These bookings will be eager loaded and ordered and will include users and courts.
  def all_bookings
    if allow?(:bookings, :edit)
      Booking.includes(:user, :court).ordered.load
    else
      bookings.includes(:court).ordered.load
    end
  end

end
