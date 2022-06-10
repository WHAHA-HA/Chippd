class PageWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :pages, :retry => 0, :backtrace => true, :failures => :all
end