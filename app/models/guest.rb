###
# A guest user is an anonymous user.
# This allows for standard permissions to be managed within an object rather than
# determined in the controller.
# The permissions will be determined through a GuestPermission object.
class Guest < User

  include Permissions

  after_initialize :add_current_permissions

  ##
  # A guest user doesn't have access to any bookings so an empty ActiveRecord::Relation object is returned.
  def all_bookings
    Booking.none
  end

  ##
  # To ensure consistency a guest needs to respond to the valid? method.
  def valid?
    true
  end

end
