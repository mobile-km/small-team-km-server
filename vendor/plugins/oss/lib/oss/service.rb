module Oss

  class Service
    attr_reader :access_key_id, :secret_access_key, :connection
    def initialize(options)
      @access_key_id = options.delete :access_key_id
      @secret_access_key = options.delete :secret_access_key
      @connection = Connection.new(:access_key_id => @access_key_id, :secret_access_key => @secret_access_key)
    end

    def bucket(name)
      Bucket.new(self, name)
    end
  end

end