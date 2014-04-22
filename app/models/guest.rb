class Guest

  #TODO: permissions are an interim step until permissions are fully refactored.

  include Permissions

  attr_reader :permissions

  def initialize
    @permissions = create_permissions
    add_current_permissions
  end

  def all_bookings
    Booking.none
  end

  def valid?
    true
  end

  # TODO: remove this once permissions/policies have been removed
  def admin?
    false
  end

  def allowed_actions
    AllowedAction.none
  end

  def bookings
    Booking.none
  end

private

  def create_permissions
    Permissions::basic_permissions.collect { |k,v| AllowedAction.new(v)}
  end

end