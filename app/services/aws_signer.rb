require 'base64'
require 'openssl'
require 'cgi'

class AwsSigner
  attr_reader :file_name, :mime_type

  def initialize(file_name, mime_type)
    @file_name = file_name.gsub(/[^\w\.\-]/, '_')
    @mime_type = mime_type
  end

  def url
    "#{s3_base_url}/#{s3_upload_bucket}/#{file_path}"
  end

  def signed_url
    params = "AWSAccessKeyId=#{CGI.escape(s3_access_key_id)}" +
             "&Expires=#{expiration}" +
             "&Signature=#{signature}"
    "#{url}?#{params}"
  end

  def signing_string
    "PUT\n\n#{mime_type}\n#{expiration}\n#{headers}\n/#{s3_upload_bucket}/#{file_path}"
  end

  def signature
    @signature ||= cgi_escaped_signature
  end

  private

  def cgi_escaped_signature
    CGI.escape(base64_encoded_signature)
  end

  def base64_encoded_signature
    Base64.strict_encode64(hmac_digest_signature)
  end

  def hmac_digest_signature
    OpenSSL::HMAC.digest('sha1', s3_secret_access_key, signing_string)
  end

  def file_path
    @file_path ||= "#{DateTime.now.utc.strftime("%Y/%m/%d/%H/%M")}/#{SecureRandom.hex}/#{file_name}"
  end

  def headers
    'x-amz-acl:public-read'
  end

  def s3_base_url
    configatron.s3.base_url
  end

  def s3_upload_bucket
    configatron.s3.upload_bucket_name
  end

  def s3_secret_access_key
    configatron.s3.secret_access_key
  end

  def s3_access_key_id
    configatron.s3.access_key_id
  end

  # Five minutes from now
  def expiration
    @expiration ||= Time.now.to_i + (60 * 5)
  end
end
