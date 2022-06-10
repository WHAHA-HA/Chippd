class Admin::FaqsController < Admin::BaseController
  protected

  def collection
    @collection ||= resource_class.all
  end
end
