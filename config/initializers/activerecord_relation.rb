module ActiveRecord

  #
  # These two methods regain the elegance of first_or_initialize
  # without hitting the database.
  # The down side is that you may get a point at which two people try to submit
  # the same record. This will be rare and will be covered by validations.
  # The down side is worth the hassle for the performance improvement.
  # As a rule using select instead of find_by has saved @0.25s / request.
  #
  class Relation
    def select_with(attributes)
      select { |relation| attributes.all? { |k,v| relation.send(k) == v} }
    end

    def select_first_or_initialize(attributes, &block)
      select_with(attributes).first || new(attributes, &block)
    end
  end
end