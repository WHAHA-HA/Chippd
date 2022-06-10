class MobileAuthenticator
  class << self
    def authenticated_application?(token)
      application_keys.has_value?(token)
    end

    def application_keys
      {
        :ios_legacy => '$2a$10$6G.cB20dCwK1hKYJTgbrr.zMy8YrDGy77/KhFqS.gSZYWfXA0cYAa',
        :android => '$2a$10$cVhjzbqNhG03z3hD5nL7Ce9hjc2EurOspbakD/7fJdsavgkszrXSq',
        :ios => '$2a$10$AZ5d0KaV7W3Q4JDkv88QOOCXYZYL8r9q9pd27KfvEHytw6.KxL3ly'
      }
    end

    def ios_legacy?(token = nil)
      application_keys[:ios_legacy] == token
    end
  end
end
