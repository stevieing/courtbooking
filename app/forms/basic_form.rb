###
# = BasicForm
# adds a number of common methods and behaviours to form objects
# Version 2. Much better than the original but still needs some work
# More flexible. Allows for a wider range of form objects.
#
module BasicForm
  extend ActiveSupport::Concern
  include ActiveModel::Model

  included do
  end

  module ClassMethods

    #
    # All of the attributes will be delegated to the model to allow for saving and validation
    # The ActiveModel model_name will be set
    # an initialize method will be added which
    # * if nothing is passed a new object is created
    # * if an object is passed it wiil be assigned to the instance.
    # A submit method will be created which will assign all attributes to the object
    # and save them if they are valid.
    #
    def set_model(model, attributes)
      const_set(:WHITELIST, attributes.dup.extract_hash_keys.push(:id))
      attr_reader model
      delegate *const_get(:WHITELIST), to: model

      define_singleton_method :model_name do
        ActiveModel::Name.new(self, nil, model.to_s.classify)
      end

      define_method :persisted? do
        !send(model).id.nil?
      end

      instance_name = "@#{model.to_s}"
      model_const = model.to_s.classify.constantize

      ##
      # if an initializer is added when this module is included.
      # even super would not call this so you need to call the
      # build_object method.
      #
      define_method :build do |object=nil, &block|
        if object.instance_of?(model_const)
          instance_variable_set(instance_name, object)
        else
          instance_variable_set(instance_name, model_const.new(object))
          block.call unless block.nil?
        end
      end

      alias_method :initialize, :build

      define_method :submit do |params, &block|
        block.call unless block.nil?
        send(model).attributes = params.slice(*self.class.const_get(:WHITELIST))
        valid? ? save_objects : false
      end

      alias_method :save, :submit
    end
  end

  def to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end

  def process_password(params)
    params.tap do |p|
      if p[:password].blank? && p[:password_confirmation].blank?
        p.delete_all(:password, :password_confirmation)
      end
    end
  end

private

   ##
  # Check model for errors. Add each error to the errors object which can
  # be used in the form.
  #
  def check_for_errors(object)
    unless object.valid?
      object.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  #
  # must be implemented
  #
  def save_objects
  end

  ##
  # save each object wrapped within a transaction.
  # which will rollback if any save is invalid.
  # returns true or false based on the success of the transaction.
  #
  def run_transaction(&block)
     begin
      ActiveRecord::Base.transaction do
        yield
      end
      true
    rescue
      false
    end
  end

end