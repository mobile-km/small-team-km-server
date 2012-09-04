require 'nokogiri'

class RemotePage
  attr_reader :content, :title, :url, :title

  def initialize uri
    @uri = uri
    @url = @uri.to_s
  end

  def fetch &block
    request
    response_fail
    process &block

    self
  end

  protected

  def valid?
    @response.content_type == 'text/html'
  end

  def request
    do_request {|req| @response = req.get_response @uri}
    @raw = @response.body
  end

  def do_request
    case @uri
    when URI::HTTP
      yield Net::HTTP
    when URI::HTTPS
      yield Net::HTTPS
    else
      raise InvalidURLError
    end
  end

  def response_fail
    case @response
    when Net::HTTPNotFound
      raise ResourceNotFoundError
    end

    unless valid?
      raise ContentTypeError,
            'not a valid web page'
    end
  end

  def process &block
    unless @raw.blank? && @type.nil?

      @content = sanitize_html @raw
    end

    block.call(self) if block
  end

  def sanitize_html html_string
    content_buffer = Nokogiri::HTML.parse(@raw)

    @title = content_buffer.css('title').text

    content_buffer.xpath('//style' ,
                         '//script',
                         '//form'  ,
                         '//button',
                         '//comment()').remove

    content_buffer.xpath('//@*').each do |attr|
      case attr.name
      when 'href', 'src', 'alt'
        next
      else
        attr.remove
      end
    end

    [@url,
     @title,
     '================',
     content_buffer.xpath('//body').inner_html].join("<br>")
  end

  class InvalidURLError       < StandardError; end
  class ContentTypeError      < StandardError; end
  class ResourceNotFoundError < StandardError; end
end
