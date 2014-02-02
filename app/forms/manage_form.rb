module ManageForm

  # = ManageForm module
  # 
  # Add standard form object behaviour to a form object
  #
  # * Will include ActiveModel::Model
  # * adds check_for_errors method to validate each object passed and add errors to form object,
  # * adds save_objects method to save any objects and associations within an ActiveRecord transaction
  #   and return true or false based on the success of the transaction.
  #
  # == set_model class method with the model and attributes(array) arguments
  #
  # adds the following methods:
  #  * model - set an instance attribute of the models class,
  #  * persisted? - set persisted to true if the action is edit false otherwise,
  #  * verify_model - call valid? method on model and add errors to the form object,
  #  * delegate - if attributes present all calls to these attributes will be delegated to the model
  #    and accepted_attributes method created.
  #  * submit - add top level attributes to object and build associations.
  #    If the object is valid it will be saved. If the parameters need any processing this processing 
  #    needs to be placed in a process_params method. Care needs to be taken that this doesn't delete
  #    any required parameters.
  #  * initialize - if new will check if any attributes need to be initialized. If an object is passed
  #    will add that to the underlying instance varialble
  #
  # == set_associated_models class method will accept an array of associations
  #  * dependent on AssociationExtras module which must be included within parent model,
  #  * creates an associated_models method which includes associated models array,
  #  * create a verify_associated_models which will do what it says on the tin and add any errors to the form object.
  #  * create a build_associations method which will build or update the associated models depending on persisted?
  #

	def self.included(base)
		base.include(ActiveModel::Model)
		base.extend(ClassMethods)
	end

	def check_for_errors(object)
    unless object.valid?
      object.errors.each do |key, value|
        errors.add key, value
      end
    end  
  end

  def submit(params)
    _params = (self.respond_to?(:process_params) ? process_params(params) : params)
    model.attributes = _params.slice(*accepted_attributes)
    build_associations(_params) if self.respond_to? :associated_models
    if valid?
      save_objects
    else
      false
    end
  end

  def save_objects
    begin
      ActiveRecord::Base.transaction do
        model.save!
        if self.respond_to? :associated_models
          associated_models.each do |association|
            model.send("save_#{association.to_s}")
          end
        end
      end
      true
    rescue
      false
    end
  end

  module ClassMethods
  	def set_model(model, attributes = [])

      unless attributes.empty?
        accepted_attributes = attributes.dup.extract_hash_keys
        _attributes = accepted_attributes.push(:id)
        _attributes.each do |attribute|
          delegate attribute, to: model
        end
        define_method :accepted_attributes do
          accepted_attributes
        end
      end

  		instance_var = "@#{model.to_s}"

  		define_singleton_method :model_name do
  			ActiveModel::Name.new(self, nil, model.to_s.capitalize)
  		end

  		define_method :model do
  			send model
  		end

  		define_singleton_method :model_sym do
  			model
  		end

  		define_method model do
  			instance_variable_set(instance_var, model.to_s.classify.constantize.send(:new)) if instance_variable_get(instance_var).nil?
  			instance_variable_get(instance_var)
  		end

      define_method :initialize do |_model = nil|
        unless _model.nil?
          instance_variable_set(instance_var, _model)
        else
          initialize_attributes if  self.respond_to?(:initialize_attributes)
        end
      end

  		define_method :persisted? do
  			!send(model).send(:id).nil?
  		end

  		define_method "verify_#{model.to_s}" do
  			check_for_errors send(model)
  		end
  		
  	end

  	def set_associated_models(*associations)

  		define_method :associated_models do
  			associations
  		end

      associations.each do |association|
        delegate association, to: model_sym
      end

  		define_method :verify_associated_models do
    		associated_models.each do |association|
      		model.send(association).each do |object|
        		check_for_errors object
      		end
    		end
  		end

      define_method :build_associations do |params|
        associated_models.each do |association|
          unless params[association.to_s].nil?
            model.send("#{persisted? ? "update" : "build"}_#{association.to_s}".to_sym, params[association.to_s])
          end
        end
      end

      model_sym.to_s.capitalize.constantize.class_eval do
        extend AssociationExtras
        association_extras *associations
      end

  	end
  end

  module AssociationExtras

    # = AssociationExtras module
    #
    # adds some free methods to an ActiveRecord model to for use with associations
    # form objects
    #
    # == class method association_extras
    # 
    # will accept an array of associations
    # This method will add three methods for each association
    # 
    # === build_association_name
    #
    # accepts a hash and builds an association object for each key
    # hash should be in form {"1" => {"attr1" => "...", "attr2" => "...", "attr3" => "..."}}
    #
    # === save_association_name
    #
    # saves all of the association objects.
    # there is an assumption that all of the objects are valid
    #
    #
    # === update_association_name
    # 
    # this method does not save or validate any objects
    #
    # * accepts a hash of keys in the same form as the build method
    # * deletes current association and builds as new

    def association_extras(*associations)

      _associations = associations.dup

      _associations.each do |association|
        define_method("build_#{association.to_s}") do |params|
          params.each { |k, attrs| self.send(association).build(attrs) }
        end
      
        define_method("save_#{association.to_s}") do 
          self.send(association).each { |o| o.save! }
        end

        define_method("update_#{association.to_s}") do |params|
          _params = params.dup
          self.send(association).delete_all
          self.send("build_#{association.to_s}", _params)
        end
      end
    end
  end

end