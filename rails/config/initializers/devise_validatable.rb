#
# It is possible that more than one user may have the same email address.
# Therefore it is not pertinent to validate_uniqueness_of email.
#

module Devise
  module Models
    module Validatable
      def self.included(base)
        base.class_eval do
          validates_presence_of     :email, :if => :email_required?
          validates_format_of       :email, :with  => email_regexp, :allow_blank => true, :if => :email_changed?
          validates_presence_of     :password, :if => :password_required?
          validates_confirmation_of :password, :if => :password_required?
          validates_length_of       :password, :within => password_length, :allow_blank => true
        end
      end
    end
  end
end