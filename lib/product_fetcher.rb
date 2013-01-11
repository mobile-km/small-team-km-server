# -*- coding: utf-8 -*-
class ProductFetcher
  def initialize(barcode, format)
    @code   = barcode
    @format = format
  end

  def fetch
    @name   = fetch_name
    @vendor = fetch_vendor
    return self
  end

  def create_product
    raise BadBarcodeError.new('错误的商品条码') unless product_created?
  end

  def result
    return unless @name
    {:name => @name, :vendor => @vendor, :code => @code, :code_format => @format}
  end

private

  def product_created?
    !Product.create(self.result).errors.any?
  end

  def name_url_template(code, format)
    URI("http://android.wochacha.com/Qrsearch/Price?barcode=#{code}&encoding=#{format}")
  end

  def vendor_url_template(code)
    URI("http://search.anccnet.com/searchResult.aspx?keyword=#{code}")
  end

  def fetch_name
    parse_response Net::HTTP.get(name_url_template(@code, @format)),
                   '.commodity_title font'
  end

  def fetch_vendor
    parse_response Net::HTTP.get(vendor_url_template(@code)),
                   '#firm_name'
  end

  def parse_response(response, html_node)
    Nokogiri::HTML(response).css(html_node).each {|node| break node.content}
  end

  class BadBarcodeError < Exception; end
end
