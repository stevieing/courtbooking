class CourtsForm
  include ActiveModel::Model

  WHITELIST = PERMITTED_ATTRIBUTES.court.whitelist.dup.extract_hash_keys.push(:id)
  ASSOCIATIONS = [:opening_times, :peak_times]

  Court.class_eval do
    extend AssociationExtras
    association_extras *ASSOCIATIONS
  end

  delegate *WHITELIST, to: :court
  delegate *ASSOCIATIONS, to: :court

  validate :verify_court
  validate :verify_associated_models

  def self.model_name
    ActiveModel::Name.new(self, nil, "Court")
  end

  def persisted?
    !court.id.nil?
  end

  def court
    @court ||= Court.new
  end

  def initialize(object=nil)
    if object.instance_of?(Court)
      @court = object
    else
      court.number = Court.next_court_number
    end
  end

  def submit(params)
    court.attributes = params.slice(*WHITELIST)
    build_associations(params)
    valid? ? save_objects : false
  end

private

  def verify_court
    check_for_errors court
  end

  def save_objects
    begin
      ActiveRecord::Base.transaction do
        court.save
        ASSOCIATIONS.each do |association|
          court.send("save_#{association.to_s}")
        end
      end
      true
    rescue
      false
    end
  end

  def check_for_errors(object)
    unless object.valid?
      object.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  def verify_associated_models
    ASSOCIATIONS.each do |association|
      court.send(association).each do |object|
        check_for_errors object
      end
    end
  end

  def build_associations(params)
    ASSOCIATIONS.each do |association|
      unless params[association.to_s].nil?
        court.send("#{persisted? ? "update" : "build"}_#{association.to_s}".to_sym, params[association.to_s])
      end
    end
  end

end