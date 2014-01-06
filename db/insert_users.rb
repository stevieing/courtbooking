require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :host     => "db/development.sqlite3"
)