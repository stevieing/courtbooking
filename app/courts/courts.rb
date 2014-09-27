module Courts

  #
  # = Courts
  #
  #  Creates a grid of cells for the courts resource.
  #  Allows users to view what's going on on the courts
  #  on a particular day.
  #

  extend ActiveSupport::Autoload

  autoload :Tab
  autoload :Closures
  autoload :Calendar

end