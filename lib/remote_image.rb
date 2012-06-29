require 'mime/types'

class RemoteImage
  attr_reader :file, :name, :type

  def initialize uri
    @uri  = uri
    @name = File.basename(@uri.path)
  end

  def fetch autoclean = true, &block
    clean
    request
    response_fail
    write_image autoclean, &block

    self
  end

  def clean
    close
    @file && File::unlink(@file.path)

    @response = nil
    @file     = nil
    @raw      = nil
    @type     = nil

    self
  end

  def close
    @file && !@file.closed? && @file.close

    self
  end

  protected

  def mime_type mime_string
    MIME::Types[mime_string].first
  end

  def image? content_type
    content_type.media_type == 'image'
  end

  def request
    do_request {|req| @response = req.get_response @uri}
    @type     = mime_type @response.content_type
    @raw      = @response.body
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

    unless image? @type
      raise ContentTypeError,
            'not a valid image'
    end
  end

  def write_image autoclean = true, &block
    unless @raw.blank? && @type.nil?
      @file = Tempfile.new([@name, ".#{@type.sub_type}"]).binmode
      @file.write @raw
    end

    block.call(self) if block

    autoclean && clean
  end

  class InvalidURLError < StandardError; end
  class ContentTypeError < StandardError; end
  class ResourceNotFoundError < StandardError; end
end
