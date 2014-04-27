module Permissions
  class BasePermission

    def allow?(controller, action, resource = nil)
      allowed = @allow_all || allow_all?(controller.to_s, action.to_s) || @allowed_actions[[controller.to_s, action.to_s]]
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    def allow_all
      @allow_all = true
    end

    def allow_all_params
       @allow_all_params = true
    end

    def allow(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end

    def allow_param(resources, attributes, nested_attributes = nil)
      @allowed_params ||= {}
      Array(resources).each do |resource|
        @allowed_params[resource] ||= []
        @allowed_params[resource] += add_param(attributes, nested_attributes)
      end
    end

    def allow_param?(resource, attribute)
      if @allow_all_params
        true
      elsif @allowed_params && @allowed_params[resource]
        @allowed_params[resource].include? attribute
      end
    end

    def permit_params!(params)
      if @allow_all_params
        params.permit!
      elsif @allowed_params
        @allowed_params.each do |resource, attributes|
          if params[resource].respond_to? :permit
            params[resource] = params[resource].permit(*attributes)
          end
        end
      end
    end

    def allow_basic_permissions
      basic_permissions.each do |k, permission|
        allow permission[:controller], permission[:action]
      end
    end

    def allow_all?(controller, action)
      false
    end

    def permit_new!(resource, params)
      params.permit(ACCEPTED_ATTRIBUTES.send(resource))
    end

  private

    def basic_permissions
      {
        sign_in_out: {
          name: "Sign in",
          controller: "devise/sessions",
          action: [:new, :create, :destroy]
        },
        forgotten_password: {
          name: "Forgotten password",
          controller: "devise/passwords",
          action: [:new, :create, :edit, :update]
        },
        courts: {
          name: "Courts",
          controller: "courts",
          action: [:index]
        }
      }
    end

    def add_param(attributes, nested_attributes)
      nested_attributes.nil? ? Array(attributes) : [{ attributes => Array(nested_attributes)}]
    end

  end

end