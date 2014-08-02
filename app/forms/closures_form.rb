class ClosuresForm
  include ActiveModel::Model
  include OverlappingRecordsManager

  WHITELIST = PERMITTED_ATTRIBUTES.closure.whitelist.dup.extract_hash_keys.push(:id)

  delegate *WHITELIST, to: :closure
  overlapping_object :closure

  validate :check_for_errors
  validate :verify_overlapping_records_removal

  def self.model_name
    ActiveModel::Name.new(self, nil, "Closure")
  end

  def persisted?
    !closure.id.nil?
  end

  def closure
    @closure ||= Closure.new
  end

  def initialize(closure=nil)
    if closure.instance_of?(Closure)
      @closure = closure
    end
  end

  def submit(params)
    self.allow_removal = to_boolean(params[:allow_removal])
    closure.attributes = params.slice(*WHITELIST)
    valid? ? save_objects : false
  end

private

  def save_objects
    begin
      ActiveRecord::Base.transaction do
        remove_overlapping
        closure.save
      end
      true
    rescue
      false
    end
  end

  def check_for_errors
    unless closure.valid?
      closure.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  def to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
end