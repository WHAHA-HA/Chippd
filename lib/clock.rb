require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(1.minutes, 'Queueing transcoding check') { TranscodedJobCheckWorker.perform_async }
every(1.minutes, 'Queueing auction notify check') { AuctionNotifyFiveMinutesLeftWorker.perform_async }
every(1.minutes, 'Queueing auction close check') { AuctionCloseWorker.perform_async }
