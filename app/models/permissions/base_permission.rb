module Permissions
  class BasePermission
  
    def allow? (controller, action, resource = nil)
      allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
      allowed && (allowed == true || resource && allowed.call(resource))
    end
  
    def allow_all
      @allow_all = true
    end
  
    def allow(controllers, actions, &block)
      @allowed_actions ||={}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end
    
  end
  
end