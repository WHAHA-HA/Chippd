class BabyFamilyUploadHandler < UploadHandler
  def has_upload_mother?
    upload_params[:upload_mother].present?
  end

  def has_upload_father?
    upload_params[:upload_father].present?
  end

  def handle
    section.mother_image_url = upload_params[:upload_mother].first['url'] if has_upload_mother?
    section.father_image_url = upload_params[:upload_father].first['url'] if has_upload_father?
    section.activate!
    notify_client
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end
end
