###
# = BasicForm
#  *adds a number of common methods and behaviours
#
#
# == class methods:
#
# === set_model(model, attributes)
# * model - the ActiveRecord model that the form is attached to.
# * attributes - any attributes that need to be added through the form.
#
# * All of the attributes will be delegated to the model to allow for saving
#   and validation
# * The ActiveModel model_name will be set to the model.
# * an initialize method will be added which will create a new instance of the model
#
#


module BasicForm
  extend ActiveSupport::Concern
  include ActiveModel::Model

  included do
  end

  module ClassMethods

    def set_model(model, attributes)
      const_set("WHITELIST", attributes.dup.extract_hash_keys.push(:id))
      attr_reader model
      delegate *const_get("WHITELIST"), to: :model

      define_singleton_method :model_name do
        ActiveModel::Name.new(self, nil, model.to_s.classify)
      end

      define_method :initialize do
        instance_variable_set("@#{model.to_s}", model.to_s.classify.constantize.new)
      end

    end
  end

end