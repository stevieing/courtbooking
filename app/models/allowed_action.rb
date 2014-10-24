###
#
# An AllowedAction is used by the Permission class to determine whether a user can access
# a particular controller action.
class AllowedAction < ActiveRecord::Base

  validates_presence_of :name, :controller, :action
  serialize :action, Array

  has_many :permissions, dependent: :destroy

  ##
  # The action attribute is a serializable Array.
  # When the data is entered it needs to be input as a comma delimited String.
  # This needs to be converted to an Array.
  attr_writer :action_text

  before_validation :save_action_text

  ##
  # Convert the action to a comma delimited string
  def action_text
    @action_text || action.try(:join, ",")
  end

  ##
  # If it is present split the action text by commas and convert it to an Array.
  def save_action_text
    self.action = @action_text.split(",") if @action_text.present?
  end

  ##
  # The sanitized controller is used to determine permissions.
  # It may well be that the controller is a partial route e.g. admin/settings
  # It needs to split the string by backslash, singularize it and convert it to a symbol.
  def sanitized_controller
    controller.to_s.split('/').last.singularize.to_sym
  end

  def non_user_specific?
    !user_specific?
  end

end
