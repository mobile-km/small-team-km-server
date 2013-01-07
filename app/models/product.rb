class Product < ActiveRecord::Base
  attr_accessible :code, :name, :kind, :unit, :origin, :vendor
  validates :code, :name, :kind, :presence => true
  validates :code, :uniqueness => true

  def self.query(code)
    Product.where('code = ?', code).first
  end
end
