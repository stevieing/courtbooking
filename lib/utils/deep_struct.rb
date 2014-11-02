##
# inherited from OpenStruct
# ensures that all nested hashes are also converted
# to a DeepStruct.
#

class DeepStruct < OpenStruct
  def initialize(hash)
    @table = {}
    @hash_table = {}

    hash.each do |k,v|
      @table[k.to_sym] = (v.is_a?(Hash) ? self.class.new(v) : v)
      @hash_table[k.to_sym] = v

      new_ostruct_member(k)
    end

  end

  def to_h
    @hash_table
  end

  def to_a
    [].tap do |arr|
      @hash_table.each do |key, obj|
        if obj.is_a?(Hash)
          obj.each { |k,v| arr.push(k => v) }
        else
          arr << obj
        end
      end
    end
  end

  alias_method :all, :to_a

end