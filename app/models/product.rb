class Product < ActiveRecord::Base
  attr_accessible :code, :name, :kind, :unit, :origin, :vendor
  validates :code, :name, :kind, :presence => true
  validates :code, :uniqueness => true
end
