##
#
# This is ugly but this is a method that needs to be run in the initializer
# and a controller.
# TODO: Find a better way.
#

module AppSetup

  extend self

  def load_constants!
    AppSettings.load!

    AppSettings.const.slots = CourtSlots.new(
      slot_first: AppSettings.const.slot_first,
      slot_last: AppSettings.const.slot_last,
      slot_time:  AppSettings.const.slot_time
    )
  end
end