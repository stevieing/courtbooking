module HashAttributes

  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods

    def hash_attributes(*attributes)
      attr_reader *attributes
    end
  end

  def default_attributes
    {}
  end

  def set_attributes(attributes)
    default_attributes.merge(attributes).each do |k,v|
      instance_variable_set "@#{k.to_s}", v
    end
  end
end