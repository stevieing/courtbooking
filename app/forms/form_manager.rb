##
#
# TODO: The way he initializers and associated_models are created needs to be improved.
# This is a hack!
# We could also move associated models out into its own module.
#

module FormManager

  ##
  # == FormManager
  #  basic mixin for form objects
  #
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ParametersProcessor

  included do
    setup
  end

  module ClassMethods

    ##
    # create all of the necessary variables.
    # there is a problem with this.
    # during testing the associated models were
    # created over and over.
    #
    def setup
      create_initializers
      create_associated_models
    end

    def create_initializers
      @initializers = {}
    end

    def create_associated_models
      @associated_models = []
    end

    def initializers
      @initializers
    end

    def associated_models
      @associated_models
    end

    ##
    # Create the basic methods for the model
    # * delegate attribute methods to the model
    # * saves setting up attr_readers.
    # * id is added as default.
    #
    # adds the following instance methods:
    #
    # <b>model</b>                - returns the instance variable
    # <b>accepted_attributes</b>  - list of attributes which will be added to model
    # <b>model_const</b>          - returns the model const. A bit of sugar!
    # <b>initialize</b>           - creates a new instance of the underlying model
    # <b>model_name</b>           - sets the model name to the underlying models, saves renaming parameters.
    # <b>verify_model</b>         - a method to verify the model. Will run any ActiveRecord validations on the
    #                               underlying model and add any errors to the form object.

    def set_model(model, attributes)
      accepted_attributes = attributes.dup.extract_hash_keys
      accepted_attributes.push(:id).each do |attribute|
        delegate attribute, to: :model
      end

      instance_name = "@#{model.to_s}"

      define_method :accepted_attributes do
        accepted_attributes
      end

      define_method :model do
        instance_variable_get(instance_name)
      end

      define_singleton_method :model_const do
        model.to_s.classify.constantize
      end

      define_method :initialize do |object=nil|
        if object.instance_of?(self.class.model_const)
          instance_variable_set(instance_name, object)
        else
          instance_variable_set(instance_name, self.class.model_const.new(object))
          call_initializers
        end
      end

      define_singleton_method :model_name do
        ActiveModel::Name.new(self, nil, model.to_s.classify)
      end

      define_method "verify_#{model.to_s}" do
        check_for_errors send(:model)
      end

    end

    ##
    # Add an initializer. Each initializer will be called when
    # a new form object is created.
    # first argument must be an attribute of the model.
    # second argument is a block which will be called
    # after initialize.
    #
    def add_initializer(attribute, &block)
      self.initializers[attribute] = block
    end

    # == set_associated_models class method will accept an array of associations
    #  * dependent on AssociationExtras module which must be included within parent model,
    #  * <b>associated_models</b> - includes associated models array,
    #  * <b>verify_associated_models</b> - does what it says on the tin and add any errors to the form object.
    #  * <b>build_associations</b> - will build or update the associated models depending on persisted?
    #
    def set_associated_models(*associations)
      self.create_associated_models
      associations.each do |association|
        self.associated_models << association
        delegate association, to: :model
      end

      model_const.class_eval do
        extend AssociationExtras
        association_extras *associations
      end
    end

    #
    # Allows you to call a method after the form is submitted.
    #
    def after_submit(method_name)
      original_method = instance_method(:submit)
      define_method :submit do |*args|
        original_method.bind(self).call(*args)
        send method_name
      end
    end
  end

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

  ##
  # submit the form. Will add each passed attribute to the model.
  # if the object is valid it will save any objects.
  # returns true or false based on valid?
  #
  def submit(params)
    _params = process_parameters(params)
    model.attributes = _params.slice(*accepted_attributes)
    build_associations(_params)
    valid? ? save_objects : false
  end

  ##
  # save each object wrapped within a transaction.
  # which will rollback if any save is invalid.
  # returns true or false based on the success of the transaction.
  #
  def save_objects
     begin
      ActiveRecord::Base.transaction do
        model.save!
        self.class.associated_models.each do |association|
          model.send("save_#{association.to_s}")
        end
      end
      true
    rescue
      false
    end
  end

  ##
  # if this is a new record persisted should be false
  # if an existing record is passed then it should be true
  #
  def persisted?
    !model.id.nil?
  end

  ##
  # call each of the defined initializers in turn.
  # best to do this as an instance method.
  #
  def call_initializers
    self.class.initializers.each do |key, value|
      model.send("#{key.to_s}=", value.call)
    end
  end

  ##
  # process the parameters any way you like.
  # this is a holding method
  # any processing is done by overriding the method.
  #
  def process_parameters(params)
    params
  end

  ##
  # instance variables for associations
  #
  def verify_associated_models
    self.class.associated_models.each do |association|
      model.send(association).each do |object|
        check_for_errors object
      end
    end
  end

  ##
  # If it is an existing record we need to update the association.
  # Otherwise the records will just be doubled.
  # TODO: improve the way this is managed. At the moment they are deleted an recreated.
  #
  def build_associations(params)
    self.class.associated_models.each do |association|
      unless params[association.to_s].nil?
        model.send("#{persisted? ? "update" : "build"}_#{association.to_s}".to_sym, params[association.to_s])
      end
    end
  end

end