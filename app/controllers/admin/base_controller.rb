class Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!
  before_filter :setup_list_breadcrumb, :except => [:index, :sort, :toggle_visibility, :home, :markdown_preview]
  before_filter :setup_new_breadcrumb, :only => [:new, :create]
  before_filter :setup_edit_breadcrumb, :only => [:edit, :update]
  before_filter :setup_show_breadcrumb, :only => [:show]

  helper_method :resource_class, :collection, :resource, :parent, :collection_path,
                :resource_path, :new_resource_path, :edit_resource_path, :toggle_visibility_resource_path,
                :sort_collection_path, :singular_resource, :plural_resource, :text_content


  respond_to :html
  respond_to :js, :only => [:toggle_visibility, :sort]

  has_scope :page, :default => 1
  has_scope :per, :default => 50

  def index
    respond_with(collection)
  end

  def sort
    sort_collection
    respond_with(collection) do |format|
      format.js { head :ok }
    end
  end

  def new
    build_resource
    respond_with(resource)
  end

  def edit
    respond_with(resource)
  end

  def create
    create_resource
    respond_with(:admin, resource)
  end

  def update
    update_resource
    respond_with(:admin, resource)
  end

  def destroy
    destroy_resource
    respond_with(:admin, resource)
  end

  def toggle_visibility
    toggle_resource_visibility
    respond_with(:admin, resource)
  end

  def home
  end

  def markdown_preview
    if params[:data]
      @preview = markdown(params[:data])
      render :layout => false
    else
      head :ok
    end
  end

  protected

  def resource_class
    controller_name.classify.constantize
  end

  def collection_name
    controller_name
  end

  def resource_name
    controller_name.singularize
  end

  def singular_resource
    resource_name.humanize.titleize.singularize
  end

  def plural_resource
    collection_name.humanize.titleize
  end

  def collection
    @collection ||= resource_class.page(params[:page]).per(params[:per])
  end

  def resource
    @resource ||= resource_class.find(params[:id])
  end

  def parent
    raise "Override in subclass"
  end

  def module_prefix
    "admin"
  end

  def constructed_route(resource_segment, prefix_segment = nil)
    [prefix_segment, module_prefix, resource_segment, 'path'].compact.join('_').to_sym
  end

  def collection_path
    send(constructed_route(collection_name))
  end

  def resource_path(_resource)
    send(constructed_route(resource_name), _resource)
  end

  def new_resource_path
    send(constructed_route(resource_name, 'new'))
  end

  def edit_resource_path(_resource)
    send(constructed_route(resource_name, 'edit'), _resource)
  end

  def toggle_visibility_resource_path(_resource)
    send(constructed_route(resource_name, 'toggle_visibility'), _resource)
  end

  def sort_collection_path
    send(constructed_route(collection_name, 'sort'))
  end

  def build_resource
    @resource = resource_class.new(params[resource_name.to_sym])
  end

  def create_resource
    build_resource
    resource.save
  end

  def update_resource
    resource.update_attributes(params[resource_name.to_sym])
  end

  def destroy_resource
    resource.destroy
  end

  def sort_collection
    collection.each do |object|
      if position = params["#{resource_class.to_s.downcase}-rows".to_sym].index(dom_id(object))
        object.move_to!(position + 1)
      end
    end
  end

  def toggle_resource_visibility
    resource.toggle_visibility!
  end

  def setup_list_breadcrumb
    ariane.add plural_resource, collection_path
  end

  def setup_new_breadcrumb
    ariane.add "New #{singular_resource}", new_resource_path
  end

  def setup_edit_breadcrumb
    ariane.add "Edit #{singular_resource}", edit_resource_path(resource)
  end

  def setup_show_breadcrumb
    ariane.add singular_resource, resource_path(resource)
  end
end
