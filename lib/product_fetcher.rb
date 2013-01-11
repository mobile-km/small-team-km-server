# -*- coding: utf-8 -*-
class ProductFetcher
  NAME_URL   = 'http://android.wochacha.com/Qrsearch/Price'
  VENDOR_URL = 'http://search.anccnet.com/searchResult.aspx'
  
  def initialize(barcode, format)
    @code   = barcode
    @format = format
    build_request_urls
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

  def build_request_urls
    @name_request_url   = URI("#{NAME_URL}?barcode=#{@code}&encoding=#{@format}")
    @vendor_request_url = URI("#{VENDOR_URL}?keyword=#{@code}")
  end

  def fetch_name
    parse_name Net::HTTP.get(@name_request_url)
  end

  def fetch_vendor
    parse_vendor Net::HTTP.get(@vendor_request_url)
  end

  def parse_name(response)
    Nokogiri::HTML(response).css('.commodity_title font').each {|name| break name.content}
  end

  def parse_vendor(response)
    Nokogiri::HTML(response).css('#firm_name').each {|name| break name.content}
  end

  class BadBarcodeError < Exception; end
end
