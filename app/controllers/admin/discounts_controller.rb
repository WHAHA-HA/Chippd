class Admin::DiscountsController < Admin::BaseController
  def create
    create_resource
    respond_with(:admin, resource) do |format|
      if resource.valid?
        format.html { redirect_to admin_discounts_url }
      else
        format.html { render 'new' }
      end
    end
  end

  def update
    update_resource
    respond_with(:admin, resource) do |format|
      if resource.valid?
        format.html { redirect_to admin_discounts_url }
      else
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    destroy_resource
    respond_with(:admin, resource) do |format|
      format.html { redirect_to admin_discounts_url }
    end
  end

  def toggle_visibility
    toggle_resource_visibility
    respond_with(:admin, resource) do |format|
      format.html { redirect_to admin_discounts_url }
    end
  end

  protected

  def edit_resource_path(_resource)
    _resource.is_a?(PercentageDiscount) ? edit_admin_percentage_discount_url(_resource) : edit_admin_dollar_amount_discount_url(_resource)
  end

  def collection_name
    "Discounts"
  end

  def collection_path
    admin_discounts_path
  end
end
