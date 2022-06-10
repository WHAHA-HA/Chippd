class Admin::ProductsController < Admin::BaseController
  skip_before_filter :setup_list_breadcrumb
  skip_before_filter :setup_new_breadcrumb
  skip_before_filter :setup_edit_breadcrumb

  before_filter :setup_parent_breadcrumbs
  before_filter :setup_new_breadcrumb, :only => [:new, :create]
  before_filter :setup_edit_breadcrumb, :only => [:edit, :update]

  def create
    create_resource
    respond_with(:admin, parent, resource, :location => collection_path)
  end

  def update
    update_resource
    respond_with(:admin, parent, resource, :location => collection_path)
  end

  def destroy
    destroy_resource
    respond_with(:admin, parent, resource, :location => collection_path)
  end

  def toggle_visibility
    toggle_resource_visibility
    respond_with(:admin, parent, resource, :location => collection_path)
  end

  protected

  def setup_parent_breadcrumbs
    ariane.add "Collections", admin_product_collections_path
    ariane.add parent.name, edit_admin_product_collection_path(parent)
    ariane.add plural_resource, collection_path
  end

  def setup_new_breadcrumb
    ariane.add "New #{singular_resource}", new_resource_path
  end

  def setup_edit_breadcrumb
    ariane.add "Edit #{singular_resource}", edit_resource_path(resource)
  end

  def parent
    @parent ||= ProductCollection.find(params[:product_collection_id])
  end

  def resource_class
    Product
  end

  def collection
    @collection ||= parent.products.page(params[:page]).per(params[:per])
  end

  def resource
    @resource ||= parent.products.find(params[:id])
  end

  def build_resource
    @resource = parent.products.new(params[resource_name.to_sym])
  end

  def collection_path
    admin_product_collection_products_path(parent)
  end

  def resource_path(_resource)
    admin_product_collection_product_path(parent, _resource)
  end

  def new_resource_path
    new_admin_product_collection_product_path(parent)
  end

  def edit_resource_path(_resource)
    edit_admin_product_collection_product_path(parent, _resource)
  end

  def toggle_visibility_resource_path(_resource)
    toggle_visibility_admin_product_collection_product_path(parent, _resource)
  end

  def sort_collection_path
    sort_admin_product_collection_products_path(parent)
  end
end
