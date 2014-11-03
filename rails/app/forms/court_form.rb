class CourtForm
  include BasicForm

  set_model :court, PERMITTED_ATTRIBUTES.court.whitelist

  ASSOCIATIONS = [:opening_times, :peak_times]

  Court.class_eval do
    extend AssociationExtras
    association_extras *ASSOCIATIONS
  end

  delegate *ASSOCIATIONS, to: :court

  validate :verify_court
  validate :verify_associated_models

  def initialize(object=nil)
    build(object) do
      court.number = Court.next_court_number
    end
  end

  def submit(params)
    build_associations(params)
    push_and_save(params)
  end

private

  def verify_court
    check_for_errors court
  end

  def save_objects
    run_transaction do
      court.save
      ASSOCIATIONS.each do |association|
        court.send("save_#{association.to_s}")
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