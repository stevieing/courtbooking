class MembersForm
  include ActiveModel::Model

  WHITELIST = PERMITTED_ATTRIBUTES.member.whitelist.dup.extract_hash_keys.push(:id)

  attr_reader :member
  delegate *WHITELIST, to: :member

  validate :verify_member

  def self.model_name
    ActiveModel::Name.new(self, nil, "Member")
  end

  def persisted?
    !member.id.nil?
  end

  def initialize(member=nil)
    if member.instance_of?(Member)
      @member = member
    else
      @member = Member.new
    end
  end

  def submit(params)
    member.attributes = process_password(params).slice(*WHITELIST)
    valid? ? save_objects : false
  end

  def include_action?(allowed_action)
    member.permissions.pluck(:allowed_action_id).include?(allowed_action.id)
  end

private

  def process_password(params)
    params.tap do |p|
      if persisted? && p[:password].blank? && p[:password_confirmation].blank?
        p.delete_all(:password, :password_confirmation)
      end
    end
  end

  def save_objects
    begin
      ActiveRecord::Base.transaction do
        member.save
      end
      true
    rescue
      false
    end
  end

  def verify_member
    check_for_errors member
  end

  def check_for_errors(object)
    unless object.valid?
      object.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

end