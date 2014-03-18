module AssociationExtras

    # = AssociationExtras module
    #
    # adds some free methods to an ActiveRecord model to for use with associations
    # form objects
    #
    # == class method association_extras
    #
    # will accept an array of associations
    # This method will add three methods for each association
    #
    # === build_association_name
    #
    # accepts a hash and builds an association object for each key
    # hash should be in form {"1" => {"attr1" => "...", "attr2" => "...", "attr3" => "..."}}
    #
    # === save_association_name
    #
    # saves all of the association objects.
    # there is an assumption that all of the objects are valid
    #
    #
    # === update_association_name
    #
    # this method does not save or validate any objects
    #
    # * accepts a hash of keys in the same form as the build method
    # * deletes current association and builds as new

    def association_extras(*associations)

      _associations = associations.dup

      _associations.each do |association|
        define_method("build_#{association.to_s}") do |params|
          params.each { |k, attrs| self.send(association).build(attrs) }
        end

        define_method("save_#{association.to_s}") do
          self.send(association).each { |o| o.save! }
        end

        define_method("update_#{association.to_s}") do |params|
          _params = params.dup
          self.send(association).delete_all
          self.send("build_#{association.to_s}", _params)
        end
      end
    end
  end