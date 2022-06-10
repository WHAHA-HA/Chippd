class ProcessingWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :pages, :retry => 5, :backtrace => true, :failures => :all

  # Retry delay, in seconds.
  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40)
  end

  # When all retries have been run and
  # we're still failing...
  sidekiq_retries_exhausted do |msg|
    AdminMailer.processing_failed(msg).deliver
  end
end