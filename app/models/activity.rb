class Activity < ActiveRecord::Base
	validates_presence_of :description, :date_from, :time_from, :time_to, :courts

	has_many :occurrences, dependent: :destroy
	has_many :courts, through: :occurrences

	validates :time_from, :time_to, time: true
	validates_with TimeAfterTimeValidator


	include Slots::ActiveRecordSlots

  scope :without, ->(activity) { where.not(id: activity.id) }

end
