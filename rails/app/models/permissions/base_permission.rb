module Permissions

  ##
  # BasePermission contains all of the necessary methods for building a permissions object.
  # Example behaviour:
  #
  #  class ChildPermission < Permissions::BasePermission
  #   def initialize(user)
  #    allow [:controller1], [:action1, :action2]
  #    allow_param [:class1], [:attribute1, :attribute2]
  #   end
  #  end
  #
  # And then in controller or model:
  #
  #  permissions = Permissions.permission_for(child)
  #
  # And then in the controller or view:
  #
  #  permissions.allow?(:controller, :action)
  class BasePermission

    def initialize(user)
      @allowed_actions = {}
      @allowed_params = {}
    end

    ##
    # Checks whether a given action is allowed for a particular controller.
    # If the object is set to allow all then this will any action will be allowed.
    # If the object allows all for a particular action then the resource will not need to be checked.
    # If the resource is passed e.g. booking then this will be compared against the user to
    # ensure that they belong to each other.
    # A block can also be passed for example in a view:
    #
    #  <% allow? controller, action %>
    #   do something
    #  <% end %>
    def allow?(controller, action, resource = nil)
      allowed = @allow_all || allow_all?(controller.to_s, action.to_s) || @allowed_actions[[controller.to_s, action.to_s]]
      allow = allowed && (allowed == true || resource && allowed.call(resource))
      block_given? && allow ? yield : allow
    end

    ##
    # Allow all actions
    def allow_all
      @allow_all = true
    end

    ##
    # Allow all parameters.
    def allow_all_params
       @allow_all_params = true
    end

    ##
    # This will add any actions to a whitelist which will be checked against using the allow? method
    # Example:
    #
    #  class SomeUserPermissions < BasePermission
    #   allow [:controller1, :controller2], [:action1, :action2] do |object|
    #    object.user_id == user.id
    #   end
    #  end
    #
    # If no block is passed it is assumed the controllers and actions are whitelisted.
    def allow(controllers, actions, &block)
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end

    ##
    # This will add any attributes for a particular resource to be added to a a whitelist which will
    # be checked using the allow_param? method.
    # There is an allowance for nested parameters i.e. for associations.
    #
    # Example:
    #
    #  allow_param [:class1], [:attribute1, :attribute2] = @allowed_params[:class1] => [:attribute1, :attribute2]
    #  allow_param [:class1], [:association1], [:attribute1, :attribute2] = @allowed_params[:class1] => [{:association1 => [:attribute1, :attribute2]}]

    def allow_param(resources, attributes, nested_attributes = nil)
      Array(resources).each do |resource|
        @allowed_params[resource] ||= []
        @allowed_params[resource] += add_param(attributes, nested_attributes)
      end
    end

    ##
    # Will check whether the passed resource and attribute is allowed
    # If allow all params is set it will always be allowed.
    # Otherwise will be checked against the list of allowed params
    #
    def allow_param?(resource, attribute)
      if @allow_all_params
        true
      elsif @allowed_params && @allowed_params[resource]
        @allowed_params[resource].include? attribute
      end
    end

    ##
    # Useful for whitelisting attributes in the controller.
    # Based on the list aof allowed parameters.
    # params must be of type ActionController::Parameters
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

    ##
    # Give the user access to basic stuff like signing in and courts page.
    def allow_basic_permissions
      basic_permissions.each do |k, permission|
        allow permission[:controller], permission[:action]
      end
    end

    ##
    # Needs to be overriden
    def allow_all?(controller, action)
      false
    end

    ##
    # params must be of type ActionController::Parameters
    # will ensure that any paramters that are passed to the new action
    # will be whitelisted as long as they are part of the allowed
    # parameters
    def permit_new!(resource, params)
      params.permit(PERMITTED_ATTRIBUTES.send(resource).whitelist)
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
        },
        calendars: {
          name: "Calendars",
          controller: "api/calendars",
          action: [:show]
        },
        api_courts: {
          name: "Courts",
          controller: "api/courts",
          action: [:show]
        }
      }
    end

    def add_param(attributes, nested_attributes)
      nested_attributes.nil? ? Array(attributes) : [{ attributes => Array(nested_attributes)}]
    end

  end

end