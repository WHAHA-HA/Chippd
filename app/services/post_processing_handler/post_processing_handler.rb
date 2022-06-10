class PostProcessingHandler
  attr_reader :section, :message

  def self.handle(section, message)
    new(section, message).handle
  end

  def initialize(section, message)
    @section = section
    @message = message
  end

  def handle
    raise Chippd::ImplementInSubclassError
  end

  protected

  def state
    message['state'] # 'COMPLETED' or 'ERROR'
  end

  def job_id
    message['jobId']
  end

  def directory_path
    message['outputKeyPrefix']
  end

  def filename
    @filename ||= Pathname.new(message['input']['key']).basename('.*').to_s
  end

  def filepath
    "#{directory_path}#{filename}"
  end

  def notify_client(success=true)
    DeliverPusherEventWorker.perform_in(5.seconds, section.to_param, success)
  end

  def raise_processing_exception!(e)
    exception = Chippd::PostProcessingError.new(e)
    exception.bugsnag_meta_data = exception_meta_data
    raise exception
  end

  def exception_meta_data
    {
      :section_id => section.to_param
    }
  end
end
