class EventsForm
  include ActiveModel::Model
  include OverlappingRecordsManager

  WHITELIST = PERMITTED_ATTRIBUTES.event.whitelist.dup.extract_hash_keys.push(:id)

  attr_reader :event
  delegate *WHITELIST, to: :event
  overlapping_object :event

  validate :verify_event
  validate :verify_overlapping_records_removal

  def self.model_name
    ActiveModel::Name.new(self, nil, "Event")
  end

  def persisted?
    !event.id.nil?
  end

  def initialize(event=nil)
    if event.instance_of?(Event)
      @event = event
    else
      @event = Event.new
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

  def verify_event
    check_for_errors event
  end

  def check_for_errors(object)
    unless object.valid?
      object.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  def to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
end