##
#
# This is ugly but this is a method that needs to be run in the initializer
# and a controller.
# TODO: Find a better way.
#
#
#
# To load redis (development mode:
#     launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
# Or, if you don't want/need launchctl, you can just run:
#     redis-server /usr/local/etc/redis.conf
#

module AppSetup

  extend self

  def load_constants!
    AppSettings.load!

    AppSettings.const.slots = Slots::Base.new(
      slot_first: AppSettings.const.slot_first,
      slot_last: AppSettings.const.slot_last,
      slot_time:  AppSettings.const.slot_time,
      courts: Court.ordered
    )
  end
end