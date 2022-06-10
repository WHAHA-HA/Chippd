Sidekiq.configure_server do |config|
  config.failures_default_mode = :all
  config.server_middleware do |chain|
    chain.add Kiqstand::Middleware
  end

  # Customer Redis Namespace in development
  if Rails.env.development? || Rails.env.test?
    config.redis = { :url => (ENV["BOXEN_REDIS_URL"] || 'redis://localhost:6379'), :namespace => "chippd-#{Rails.env}" }
  end
end

Sidekiq.configure_client do |config|
  # Customer Redis Namespace in development
  if Rails.env.development? || Rails.env.test?
    config.redis = { :url => (ENV["BOXEN_REDIS_URL"] || 'redis://localhost:6379'), :namespace => "chippd-#{Rails.env}" }
  end
end

class Sidekiq::Extensions::DelayedMailer
  sidekiq_options :queue => :mailer, :retry => 4, :backtrace => true, :failures => :exhausted
end