class KeyGenerator
  def self.generate(seed, length = 5)
    Gibberish::SHA256(digestable_string(seed))[1..length].upcase
  end

  def self.digestable_string(seed)
    [Time.now.to_s, seed, Object.new.object_id].join('--')
  end
end
