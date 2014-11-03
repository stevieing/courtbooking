class PermittedAttributes

  ##
  # = Permitted Attributes
  #
  # These should be loaded from a yaml file in the following format:
  # model_a:
  #   whitelist:
  #     - :attr_a
  #     - :attr_b
  #     - :model_ids: []
  #   nested:
  #     :model_b:
  #       - :attr_c
  #       - :attr_d
  #   virtual:
  #     - :attr_e
  #
  # All attributes should be symbols
  #
  # == Whitelist
  #  These are the main top level attributes which should be permitted.
  #  You can permit a belongs to relationship with :model_ids: []
  #
  # == Nested
  #   Any attributes permitted via associations. Usually has many through
  #   Each sub category name will be the association.
  #
  # == Virtual
  #   Virtual attributes are those which need permitting but are not attached to a model
  #
  #
  #


  def initialize(file)
    @struct = DeepStruct.new(YAML.load_file(file))
    @struct.to_h.keys.each do |key|
      define_singleton_method key, proc { @struct.send(key.to_sym) }
    end
  end

end