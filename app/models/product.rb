class Product < ActiveRecord::Base
  attr_accessible :code, :name, :kind, :unit, :origin, :vendor
  validates :code, :name, :kind, :presence => true
  validates :code, :uniqueness => true

  def self.query(code)
    Product.where('code = ?', code)
  end

  def to_hash
    return {
      :id   => self.id,
      :code => self.code,
      :name => self.name,
      :kind => self.kind,
      :unit => self.unit,
      :origin => self.origin,
      :vendor => self.vendor,
      :server_created_time => self.created_at.to_i,
      :server_updated_time => self.updated_at.to_i
    }
  end
end
