class HeaderSanitizer
  class << self
    def sanitize!(headers = {})
      new(headers).sanitize!
    end
  end

  def initialize(headers = {})
    @headers = headers
  end

  def sanitize!
    remove_junk_keys
    clean_remaining_keys
    @headers
  end

  protected

  def remove_junk_keys
    @headers.delete_if { |key, value| %w(rack action_ warden).any? { |match| key.include?(match) } }
  end

  def clean_remaining_keys
    new_headers = {}
    @headers.each do |key, value|
      new_headers[sanitized_key(key)] = value
    end
    @headers = new_headers
  end

  def sanitized_key(key)
    key.downcase.gsub('-', '_').gsub(/^http_/, '').gsub(/^x_/, '').to_sym
  end
end
