module Oss
  class Signature
    
    def self.generate(access_key_id, secret_access_key, options)
      method = options.delete(:method)
      path   = options.delete(:path)
      headers = options.delete(:headers) || {}
      md5 = headers.delete :md5
      content_type = headers.delete :content_type


      date = Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')

      oss_sign = ali_oss_sign(secret_access_key, method, date, path,
        :headers => headers, :md5 => md5, :content_type => content_type)

      hash = {'Authorization' => "OSS #{access_key_id}:#{oss_sign}", 'Date' => date}

      hash.merge!(headers) if !headers.blank?
      hash.merge!("Content-Md5" => md5) if !md5.blank?
      hash.merge!("Content-Type" => content_type) if !content_type.blank?

      hash
    end

    private
    def self.ali_oss_sign(secret_access_key, verb, date, res,options={})
      digest  = OpenSSL::Digest::Digest.new('sha1')

      md5 = options[:md5] || ''
      ty = options[:content_type] || ''

      header = ''
      unless options[:headers].blank?
        headers = options[:headers]
        header = headers.keys.sort.map{|keya|"#{keya}:#{headers[keya]}"}*"\n" + "\n"
      end

      str = "#{verb}\n#{md5}\n#{ty}\n#{date}\n#{header}#{res}"
      
      bytemac = OpenSSL::HMAC.digest(digest, secret_access_key, str)
      res = Base64.encode64(bytemac).strip
    end

  end
end

