module Oss
  class Bucket
    class ACL
      PUBLIC_READ = "public-read"
    end

    attr_reader :service, :name
    def initialize(service, bucket_name)
      @service = service
      @connection = @service.connection
      @name = bucket_name
    end

    def create
      @connection.request(:put, :path => "/#{@name}")
    end

    def set_acl(acl)
      @connection.request(:put, :path => "/#{@name}", :headers => {"x-oss-acl"=>acl})
    end

    def object(object_name)
      Oss::Object.new(self, object_name)
    end

  end
end