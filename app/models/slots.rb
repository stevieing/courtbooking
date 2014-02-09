class Slots

	include Enumerable

	attr_accessor :slots

	#TODO: quick fix while I refactor slots.
	delegate :empty?, :last, to: :slots

	def initialize(options = nil)
		unless options.nil?
			@courts_opening_time = options[:courts_opening_time]
			@courts_closing_time = options[:courts_closing_time]
			@slot_time = options[:slot_time]
			@slots = create_slots
			reset!
		end
	end

	def each(&block)
		@slots.each(&block)
	end

	def current
		@slots[@index]
	end

	def next(slot=nil)
		slot.nil? ? @slots[@index+=1] : check_for_last_slot(slot)
	end

	def previous
		@slots[@index-=1]
	end

	def skip(n)
		@index+=n
	end

	def reset!
		@index = @slots.index(@slots.first)
	end

	def collect_range(first, last)
		@slots.find_all { |slot| slot >= first && slot <= last }
	end

	def reject_range(first, last)
		@slots.reject { |slot| slot >= first && slot <= last }	
	end

	def reject_range!(first, last)
		@slots.reject! { |slot| slot >= first && slot <= last }
	end

	alias_method :all, :slots

	private

	def check_for_last_slot(slot)
		if @slots[@slots.find_index(slot)+1].nil?
			(DateTime.parse(slot) + @slot_time.minutes).to_s(:hrs_and_mins)
		else
			@slots[@slots.find_index(slot)+1]
		end
	end

	def create_slots
		@courts_opening_time.to(@courts_closing_time, @slot_time.minutes).collect {|t| t.to_s(:hrs_and_mins)}.to_a
	end
end