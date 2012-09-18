module Oss
  module Error
    class ResponseError < StandardError
      attr_reader :response
      def initialize(message, response)
        @response = response
        super(message)
      end

      def self.exception(code)
        Oss::Error.const_get(code)
      rescue NameError
        ResponseError
      end
    end

    class NoSuchBucket < ResponseError; end
    class AccessDenied < ResponseError; end
  end
end