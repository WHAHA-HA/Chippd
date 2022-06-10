class Admin::BatchesController < Admin::BaseController
  def create
    create_resource
    respond_with(:admin, resource) do |format|
      if resource.valid?
        BatchWorker.perform_async(resource.to_param)
        format.html { redirect_to admin_batches_url }
      else
        format.html { render 'new' }
      end
    end
  end

  protected

  def plural_resource
    "Code Batches"
  end

  def singular_resource
    "Code Batch"
  end
end
