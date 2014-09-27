module Courts

  #
  # = Courts::Closure
  #
  #  This class will return all of the closures for a set of courts
  #  on a particular day.
  #
  #  Returns closures split into those which cover all of the courts
  #  and those that don't
  #

  class Closures

    include Enumerable

    attr_reader :closures, :for_all_courts

    def initialize(courts, date)
      @courts, @date = courts, date
      @for_all_courts, @closures = Closure.by_day(date).partition { |closure| closure.courts.count == no_of_courts }
    end

    def each(&block)
      closures.each(&block)
    end

  private

    def no_of_courts
      @no_of_courts ||= @courts.count
    end

  end

end