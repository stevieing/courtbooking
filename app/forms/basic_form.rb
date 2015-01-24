##
# Adds a number of common methods and behaviours to form objects
#
# Example usage:
#  class MyModelsForm
#   include BasicForm
#
#   set_model :my_model, [:attr_a, :attr_b, :attr_c]
#   validate verify_my_model
#
#   def initialize(object=nil)
#    build do
#      my_model.attr_a = "1"
#    end
#   end
#
#   def submit(params)
#    self.virtual_attribute = params[:virtual_attribute]
#    push_and_save(params)
#   end
#
#  private
#   def save_objects
#    run_transaction do
#      booking.save
#    end
#  end
module BasicForm

  extend ActiveSupport::Concern
  include ActiveModel::Model

  included do
  end

  module ClassMethods

    ##
    # All of the attributes will be delegated to the model to allow for saving and validation
    # The ActiveModel model_name will be set
    def set_model(model, attributes)
      model_sym = model.to_s.class_to_sym

      const_set(:WHITELIST, attributes.dup.extract_hash_keys.push(:id))
      attr_reader model_sym
      delegate *const_get(:WHITELIST), to: model_sym

      define_singleton_method :model_name do
        ActiveModel::Name.new(self, nil, model.to_s)
      end

      instance_name = "@#{model_sym.to_s}"

      define_method :persisted? do
        instance_variable_get(instance_name).id
      end

      ##
      # an initialize method will be added which
      # * if nothing is passed a new object is created
      # * if an object is passed it wiil be assigned to the instance.
      # if an initializer is added when this module is included.
      # even super would not call this so you need to call the
      # build method.
      define_method :build do |object=nil, &block|
        if object.kind_of?(model)
          instance_variable_set(instance_name, object)
        else
          instance_variable_set(instance_name, model.new(object))
          block.call unless block.nil?
        end
      end

      alias_method :initialize, :build

      ##
      # A submit method will be created which will assign all attributes to the object
      # and save them if they are valid.
      define_method :submit do |params, &block|
        block.call unless block.nil?
        instance_variable_get(instance_name).attributes = params.slice(*self.class.const_get(:WHITELIST))
        save
      end

      alias_method :push_and_save, :submit
    end
  end

  def to_boolean(value)
    ActiveRecord::Type::Boolean.new.type_cast_from_database(value)
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
  def check_for_errors(object)
    unless object.valid?
      object.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  def save
    valid? ? save_objects : false
  end

  ##
  # must be implemented
  def save_objects
  end

  ##
  # save each object wrapped within a transaction.
  # which will rollback if any save is invalid.
  # returns true or false based on the success of the transaction.
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