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
  #  * adds a model method to set an instance attribute of the models class,
  #  * adds a persisted method to set persisted to true if the action is edit false otherwise,
  #  * adds a verify_model method to call valid? method on model and add errors to the form object,
  #  * if attributes present all calls to these attributes will be delegated to the model
  #    and accepted_attributes method created.
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
        _attributes = attributes.dup.push(:id)
        _attributes.each do |attribute|
          delegate attribute, to: model
        end
        define_method :accepted_attributes do
          attributes
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

  	end
  end

end