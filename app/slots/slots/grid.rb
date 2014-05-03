module Slots
  class Grid

    include Enumerable

    attr_accessor :objects
    attr_reader :original
    delegate :current, :frozen?, to: :original

    def initialize(number, original)
      @number, @original = number, original
      @objects = create_objects
    end

    def each(&block)
      @objects.each(&block)
    end

    def [](key)
      @objects[key]
    end

    def valid?
      @objects.all? { |o| o.valid? }
    end

    def synced?(index)
      @original.current == @objects[index].current
    end

    def inspect
      "<#{self.class}: @number=#{@number}, @original=#{@original.inspect}}>"
    end

    def skip(index, by)
      @objects[index].up(by)
    end

    alias_method :master, :original

  private

    def create_objects
      (1..@number).collect { |i| @original.dup }
    end
  end


end