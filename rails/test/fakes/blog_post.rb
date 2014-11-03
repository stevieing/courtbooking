class BlogPost < ActiveRecord::Base
  has_many :comments
  validates_presence_of :title
  extend AssociationExtras
  association_extras :comments
end