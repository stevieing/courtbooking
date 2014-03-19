module IndexManager

	##
	# 	This module includes Enumerable along with adding any necessary methods.
	#  	It also adds a few extra methods to allow for Index movement
	# 	through an object chain
	# 	Everything is based around an enumerator object.
	# 	The object that is the focus of Enumerable.
	# 	This object will have an index added.
	#

	extend ActiveSupport::Concern
	include Enumerable

	included do
		delegate :empty?, :last, to: :enumerator
	end

	module ClassMethods

		##
		# 	Defines an enumerator method based on
		# 	an instance variable of the class
		# 	This variable will have all of the
		# 	enumerable methods applied to it
		# 	example:
		# 		add_enumerator :attribute
		#
		def set_enumerator(enumerator)
			define_method :enumerator do
				instance_variable_get("@#{enumerator.to_s}")
			end
		end

		##
		# 	Add the reset! method to the clase
		# 	once initialize has been added.
		# 	If we didn't wait then initialize could
		# 	be rewritten or we would have to include the
 		# 	module after initalize has been added
 		#
		def method_added(method_name)
			if method_name == :initialize  && !@adding_initialize_method
				original_method = instance_method(method_name)
				begin
					@adding_initialize_method = true
					define_method method_name do |*args, &block|
			    	original_method.bind(self).call(*args, &block)
			    	reset!
			    end
			  ensure
			  	@adding_initialize_method = false
			  end
		  end
		end

	end

	def each(&block)
		enumerator.each(&block)
	end

	##
	# Get the current value of the enumerator.
	#
	def current
		enumerator[@index]
	end

	##
	# Return the index of the current value of the enumerator.
	#
	def index
		@index
	end

	##
	# Reset the index of the enumerator.
	#
	def reset!
		@index = 0
	end

	##
	# Move the index of the enumerator up by the value of n.
	#
	def up(n=1)
		@index += n
	end

	##
	# Move the index of the enumerator down by the value of n.
	#
	def down(n=1)
		@index -= n
	end

	##
	# Check whether the current value of the enumerator is at the end.
  # Not the last value but 1 above.
	#
	def end?
		@index >= enumerator.count
	end

  ##
  # check whether value is the last in the list
  #
  def last?
    current == enumerator.last
  end

end