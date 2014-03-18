class AcceptedAttributes

  #
  # = AcceptedAttributes class
  #
  # allows lists of attributes for models to be used application wide for such things as permitted params
  # it use class level attributes and config setup not constants so in development mode these can be destroyed.
  # the trick is after set up to add it to a constant:
  # AcceptedAttributes.setup do |config|
  #   config.add :model_a, :attr_a, :attr_b, :attr_c
  #   config.add_nested :model_a, :association_a, :attr_a
  # end
  # ACCEPTED_ATTRIBUTES = AcceptedAttributes.dup just to be safe!
  #
  # == add
  # add a model and its whitelisted attributes
  # This will add a class method
  # e.g. AcceptedAttributes.model_a will return [:attr_a, :attr_b, :attr_c]
  # you can add :association_ids => [] for habtm and has_many :through
  #
  # == add_nested
  #
  # add a model association and its associated attributes
  #
  # == models
  #
  # returns a hash of models
  # AcceptedAttributes.models.each do | model |
  #  model.name model.attributes
  # end
  #
  # == nested_models
  #
  # returns a hash of nested attributes
  # AcceptedAttributes.nested.each do | model |
  #  model.name model.association model.attributes
  # end
  #
  # == setup
  #
  # same old same old!
  # will remove any class level attributes and recreated them.
  #

  cattr_accessor :models
  self.models = []

  cattr_accessor :nested
  self.nested = []

  class AttributesAccessor
    attr_accessor :name, :attributes
    def initialize(attributes)
      @name, *@attributes = attributes
    end
  end

  class NestedAttributesAccessor < AttributesAccessor
    attr_accessor :association
    def initialize(attributes)
      @name, @association, *@attributes = attributes
    end
  end

  class << self
    def add(*attributes)
      new_model = AttributesAccessor.new(attributes)
      models << new_model
      define_singleton_method new_model.name do
        new_model.attributes
      end
    end

    def add_nested(*attributes)
      new_model = NestedAttributesAccessor.new(attributes)
      nested << new_model
    end

  end

  def self.remove_all
    self.models.clear
    self.nested.clear
  end

  def self.setup
    remove_all
    yield self if block_given?
  end
end