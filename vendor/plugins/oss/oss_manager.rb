class OssManager
  YML_FILE_PATH = File.join(File.dirname(File.expand_path(__FILE__)),"oss.yml")

  CONFIG = YAML.load_file(YML_FILE_PATH)[Rails.env]

  OSS_SERVICE = Oss::Service.new(:access_key_id => CONFIG["access_key_id"], :secret_access_key => CONFIG["secret_access_key"])
  OSS_BUCKET = OSS_SERVICE.bucket(CONFIG["bucket"])
  
  def self.create_bucket
    OSS_BUCKET.create
  end

  def self.set_bucket_to_public
    OSS_BUCKET.set_acl(Oss::Bucket::ACL::PUBLIC_READ)
  end

  def self.upload_file(file, save_path, content_type)
    begin
      OSS_BUCKET.object(save_path).upload(file, content_type)
    rescue ::Oss::Error::NoSuchBucket => ex
      self.create_bucket
      self.set_bucket_to_public
      retry
    rescue ::Oss::Error::ResponseError => ex
      raise
    end
  end

  def self.delete_file(save_path)
    OSS_BUCKET.object(save_path).delete
  end

  def self.get_file(save_path)
    OSS_BUCKET.object(save_path).get_file
  end

  def self.get_file_body(save_path)
    OSS_BUCKET.object(save_path).get_body
  end

  def self.get_file_meta(save_path)
    OSS_BUCKET.object(save_path).meta
  end

  def self.file_exists?(save_path)
    OSS_BUCKET.object(save_path).exists?
  end

end
