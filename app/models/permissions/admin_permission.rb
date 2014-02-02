module Permissions

  class AdminPermission < BasePermission
    def initialize(user)
      allow_all

      ACCEPTED_ATTRIBUTES.models.each do |model|
        allow_param model.name, model.attributes
      end

      ACCEPTED_ATTRIBUTES.nested.each do |nested|
        allow_nested_params nested.name, nested.association, nested.attributes
      end

    end
  end
end