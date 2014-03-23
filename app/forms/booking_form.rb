##
#
# TODO: it may be best to tackle this at a later date.
# There are some complex issues.
# How to handle the user and mailers.
# Plus there is a lot of logic that could be moved
# out from the model.
# A job for a rainy day.
#

class BookingForm
  include FormManager

  set_model :booking, ACCEPTED_ATTRIBUTES.booking
  validate :verify_booking
end