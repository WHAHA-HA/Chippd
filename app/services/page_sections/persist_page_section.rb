class PersistPageSection
  attr_reader :page, :params, :section

  def initialize(page, params)
    @page = page
    @params = params

    if params.include?(:section_js)
      section_js = JSON.parse(URI.unescape(params[:section_js]))
      section = params[:section] || {}
      section.merge!(section_js)
      params[:section] = section
    end
  end

  protected

  def handle_upload
    if upload?
      section.pend!
      queue_upload_worker
    else
      # this is a hack due to invitation image being optional
      # and default state is pending for pages with attachments
      section.activate! if section.is_a?(Invitation)
    end
  end

  def queue_upload_worker
    UploadWorker.perform_async(section.to_param, upload_params)
  end

  def upload_params
    @params.select { |k, _| k.to_s.match(/^upload.*/) }
  end

  def upload?
    !upload_params.empty?
  end

  def touch_page
    page.touch
  end
end
