class BatchWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :qr_codes, :retry => false, :backtrace => true, :failures => :all

  def perform(batch_id)
    batch = Batch.find(batch_id)
    batch.generate!
  end
end