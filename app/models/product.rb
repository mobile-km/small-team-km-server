class Product < ActiveRecord::Base
  attr_accessible :code, :name, :vendor, :code_format
  validates :code, :name, :code_format, :presence => true
  validates :code, :uniqueness => true

  def self.query(code, format)
    products = Product.where('code = ?', code)

    if products.blank?
      ProductFetcher.new(code, format).fetch.create_product
      self.query(code, format)
    end

    products
  end

  def to_hash
    return {
      :id   => self.id,
      :code => self.code,
      :name => self.name,
      :code_format => self.code_format,
      :vendor => self.vendor,
      :server_created_time => self.created_at.to_i,
      :server_updated_time => self.updated_at.to_i
    }
  end

end
