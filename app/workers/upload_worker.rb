class UploadWorker < ProcessingWorker

  def perform(section_id, upload_params)
    section = Page.find_and_return_section(section_id)
    upload_handler_class(section._type).handle(section, upload_params)
  end

  protected

  def upload_handler_class(section_type)
    "#{section_type}UploadHandler".constantize
  end

end
