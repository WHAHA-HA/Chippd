class Admin::ContentsController < Admin::BaseController
  protected

  def resource
    @resource ||= Content.find(params[:id])
  end

  def plural_resource
    "Text Content"
  end

  def setup_edit_breadcrumb
    ariane.add resource.name, edit_resource_path(resource)
  end
end
