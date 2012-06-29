require 'readability'

class RemotePage
  attr_reader :content, :title, :url

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
      # @content = Readability::Document.new(@raw,
      #                                      :tags               => %w[p img a],
      #                                      :attributes         => %w[src href],
      #                                      :remove_empty_nodes => true).content

      @content = @raw
    end

    block.call(self) if block
  end

  class InvalidURLError < StandardError; end
  class ContentTypeError < StandardError; end
  class ResourceNotFoundError < StandardError; end
end
