module AssociationExtras
  
  def association_extras(*associations)
    associations.each do |association|
      define_method("build_#{association.to_s}") do |params|
        params.each { |k, attrs| self.send(association).build(attrs) }
      end
      
      define_method("save_#{association.to_s}") do 
        self.send(association).each { |o| o.save! }
      end
    end
  end
end