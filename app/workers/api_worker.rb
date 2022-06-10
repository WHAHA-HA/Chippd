class ApiWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :api, :retry => false, :backtrace => true, :failures => :all
end