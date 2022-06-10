class UploadHandler
  attr_reader :section, :upload_params

  def self.handle(section, upload_params)
    new(section, upload_params).handle
  end

  def initialize(section, upload_params)
    @section = section
    @upload_params = {}
    upload_params.each do |k,v|
      @upload_params[k.to_sym] = JSON.parse(URI.unescape(v))
    end
  end

  def handle
    raise Chippd::ImplementInSubclassError
  end

  protected

  def notify_client(success=true)
    DeliverPusherEventWorker.perform_in(5.seconds, section.to_param, success)
  end

  def raise_processing_exception!(e)
    exception = Chippd::UploadProcessingError.new(e)
    exception.bugsnag_meta_data = exception_meta_data
    raise exception
  end

  def exception_meta_data
    {
      :section_id => section.to_param
    }
  end
end
