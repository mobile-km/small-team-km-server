# -*- coding: utf-8 -*-
class ProductFetcher
  NAME_URL = 'http://android.wochacha.com/Qrsearch/Price'
  VENDOR_URL = 'http://search.anccnet.com/searchResult.aspx'
  
  attr_reader :barcode, :format

  def initialize(barcode, format)
    @code = barcode
    @format  = format
    build_request_urls
  end

  def fetch
    @name = parse_name Net::HTTP.get(@name_request_url)
    @vendor = parse_vendor Net::HTTP.get(@vendor_request_url)
    @result = {:name => @name, :vendor => @vendor, :code => @code, :code_format => @format}
    return self
  end

  def create_product
    product = Product.create @result
    raise BadBarcodeError.new('错误的商品条码') if product.errors.any?
  end

private

  def build_request_urls
    @name_request_url = URI("#{NAME_URL}?barcode=#{@code}&encoding=#{@format}")
    @vendor_request_url = URI("#{VENDOR_URL}?keyword=#{@code}")
  end

  def parse_name(response)
    Nokogiri::HTML(response).css('.commodity_title font').each {|name| break name.content}
  end

  def parse_vendor(response)
    Nokogiri::HTML(response).css('#firm_name').each {|name| break name.content}
  end

  class BadBarcodeError < Exception; end
end
