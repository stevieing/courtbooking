##
# Allows the class to pass attributes in a hash
# Preferable where there is no certainty of which
# attributes will be passed in which order
module HashAttributes

  include Slots::Helpers

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    ##
    # A method which will create a list of default attributes
    # and assign an accessor.
    # Need to be deep dupped in case any of the attributes are objects
    # e.g. hashes or arrays. This will ensure these attributes are not
    # shared between objects
    # Example:
    #  class MyClass
    #   include HashAttributes
    #
    #   hash_attributes attr_a: "a", attr_b: "b", attr_c: "c"
    #
    #  end
    #
    # Will produce:
    #  attr_accessor :attr_a, :attr_b, :attr_c
    #
    #  def default_attributes
    #   { attr_a: "a", attr_b: "b", attr_c: "c" }
    #  end
    #
    def hash_attributes(attributes)
      define_method :default_attributes do
        attributes.deep_dup
      end

      attr_accessor *attributes.keys
    end

  end

  ##
  # Defaults to an empty hash.
  # Needs to be overriden to create defaults.
  # Prevents any complex error procedures.
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
  #   include HashAttributes
  #
  #   hash_attributes attr_a: "a", attr_b: "b", attr_c: "c"
  #
  #   def initialize(options = {})
  #     set_attributes(options)
  #   end
  #  end
  #
  #  my_model = MyModel.new(attr_c: "123", attr_d: "d")
  #  my_model.inspect => "<#MyModel: @attr_a=a, @attr_b=b, @attr_c=123, @attr_d=d>"
  #
  # Things to note:
  #  *any extra attributes passed in the initializer will be silent.
  #   They will be there but will be useless as they have no accessor or usage.
  #
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