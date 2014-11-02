##
# Allows the class to pass attributes in a hash
# Preferable where there is no certainty of which
# attributes will be passed in which order
module HashAttributes

  extend ActiveSupport::Concern
  include Slots::Helpers

  included do
  end

  module ClassMethods

    ##
    # A method which will create a list of available attributes
    # and assign a reader.
    def hash_attributes(*attributes)
      attr_reader *attributes
    end
  end

  ##
  # Defaults to an empty hash.
  # Needs to be overriden to create defaults.
  # These will be merged with any passed attributes in
  # the set_attributes method so you can always have a full
  # suite of attributes
  # Example:
  #  def default_attributes
  #   { attr_a: "a", attr_b: "b", attr_c: "c"}
  #  end
  #
  #  my_model = MyModel.new(attr_c: "d")
  #  my_model.attr_a => "a"
  #  my_model.attr_c => "d"
  def default_attributes
    {}
  end

  ##
  # This should be called inside the initializer
  # It will merge attributes with default attributes
  # and create an instance variable for each attribute
  # Example:
  #
  #  class MyModel
  #   def initialize(options = {})
  #     set_attributes(options)
  #   end
  #  end
  #
  #  my_model = MyModel.new(attr_c: "123")
  #  my_model.inspect => "<#MyModel: @attr_a=a, @attr_b=b, @attr_c=123>"
  def set_attributes(attributes)
    default_attributes.merge(attributes).each do |k,v|
      instance_variable_set "@#{k.to_s}", v
    end
  end

  ##
  # Does the same as set_attributes but will check whether any attributes
  # can be parsed to an instance of Time and if so convert them.
  def set_attributes_with_time(attributes)
    default_attributes.merge(attributes).each do |k,v|
      instance_variable_set "@#{k.to_s}", to_time(v)
    end
  end
end