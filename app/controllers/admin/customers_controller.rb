class Admin::CustomersController < Admin::BaseController

  def line_items
    @line_items = Page.all.collect { |p| p.line_items }.flatten.sort_by { |li| li.codes }
  end

  def show
    ariane.add resource.full_name, resource_path(resource)
  end

  def confirm
    resource.confirm!
  end

  protected

  def collection
    @collection ||= resource_class.order_by(:email.asc).all
  end

end
