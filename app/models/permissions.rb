module Permissions
  def self.permission_for(user)
    "Permissions::#{user.class}Permission".constantize.new(user)
  end

  extend ActiveSupport::Concern

  included do
    delegate :allow?, :permit_params!, to: :current_permissions
    delegate :permit_new!, to: :current_permissions unless self.name == "Guest"
    include_after_find
  end

  module ClassMethods
    def include_after_find
      if self.ancestors.include?(ActiveRecord::Base)
        after_find :add_current_permissions
      end
    end
  end

  def current_permissions
    @current_permissions ||= Permissions.permission_for(self)
  end

  def add_current_permissions
    @current_permissions = Permissions.permission_for(self)
  end

end