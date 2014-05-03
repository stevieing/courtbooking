class AllowedAction < ActiveRecord::Base

  validates_presence_of :name, :controller, :action
  serialize :action, Array

  has_many :permissions, dependent: :destroy

  ##
  # TODO: quick fix. The allowed action table is purely for admins.
  # This behaviour should be moved out into a form object.
  # This will be done off the back of the form objects for admin functions.
  # The assumption is that only an admin developer will complete this
  # with the knowledge of what it is being used for.
  #
  attr_writer :action_text
  before_validation :save_action_text

  def action_text
    @action_text || action.try(:join, ",")
  end

  def save_action_text
    self.action = @action_text.split(",") if @action_text.present?
  end

  def sanitized_controller
    controller.to_s.split('/').last.singularize.to_sym
  end

  def non_user_specific?
    !user_specific?
  end

end
