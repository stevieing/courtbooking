class DependentLoader
  def self.start(table, &block)
    if ActiveRecord::Base.connection.tables.include?(table.to_s) and !defined?(::Rake)
      unless Rails.env.test?
        if table.to_s.classify.constantize.all.empty?
          block.callback :success
        else
          block.callback :failure
        end
      end
    end
  end
end