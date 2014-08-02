class EventsForm
  include ActiveModel::Model
  include OverlappingRecordsManager

  WHITELIST = PERMITTED_ATTRIBUTES.event.whitelist.dup.extract_hash_keys.push(:id)

  delegate *WHITELIST, to: :event
  overlapping_object :event

  validate :check_for_errors
  validate :verify_overlapping_records_removal

  def self.model_name
    ActiveModel::Name.new(self, nil, "Event")
  end

  def persisted?
    !event.id.nil?
  end

  def event
    @event ||= Event.new
  end

  def initialize(event=nil)
    if event.instance_of?(Event)
      @event = event
    end
  end

  def submit(params)
    self.allow_removal = to_boolean(params[:allow_removal])
    event.attributes = params.slice(*WHITELIST)
    valid? ? save_objects : false
  end

private

  def save_objects
    begin
      ActiveRecord::Base.transaction do
        remove_overlapping
        event.save
      end
      true
    rescue
      false
    end
  end

  def check_for_errors
    unless event.valid?
      event.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  def to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
end