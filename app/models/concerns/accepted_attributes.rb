class AcceptedAttributes

	cattr_accessor :models
	self.models = []

	cattr_accessor :nested
	self.nested = []

	class AttributesAccessor
		attr_accessor :name, :attributes
		def initialize(attributes)
			@name, *@attributes = attributes
		end
	end

	class NestedAttributesAccessor < AttributesAccessor
		attr_accessor :association
		def initialize(attributes)
			@name, @association, *@attributes = attributes
		end
	end

	class << self
		def add(*attributes)
			new_model = AttributesAccessor.new(attributes)
			models << new_model
			define_singleton_method new_model.name do
				new_model.attributes
			end
		end

		def add_nested(*attributes)
			new_model = NestedAttributesAccessor.new(attributes)
			nested << new_model
		end

	end

	def self.remove_all
		self.models.clear
		self.nested.clear
	end

	def self.setup
		remove_all
		yield self if block_given?
	end
end