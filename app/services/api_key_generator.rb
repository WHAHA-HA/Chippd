class ApiKeyGenerator
  def self.generate
    BCrypt::Password.create(SecureRandom.uuid)
  end
end
