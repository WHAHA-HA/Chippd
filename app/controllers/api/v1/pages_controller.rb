class Api::V1::PagesController < Api::V1::BaseController
  layout 'api_message'

  before_filter :authenticate_customer!, :except => [:not_found]
  before_filter :fetch_page, :except => [:index, :not_found]

  respond_to :json, :only => [:index, :leave]
  respond_to :html, :only => [:show]

  helper_method :preview?, :editing?, :current_customer

  def index
    render :json => Api::V1::PagesPresenter.new(current_customer.memberships), :status => :ok
  end

  def show
    membership = MembershipManager.new(page, current_customer.to_param, key)
    if membership.verify!
      @page = PagePresenter.new(page, view_context)
      if page.has_sections?
        render '/my_chippd/pages/show', :layout => false
      else
        render 'no_content', :status => :ok
      end
    else
      render 'forbidden', :status => :forbidden
    end
  end

  def leave
    membership = MembershipManager.new(page, current_customer.to_param, key, false)
    if membership.exists?
      membership.cancel!
      head :ok
    else
      head :not_found
    end
  end

  def not_found
    render 'not_found', :status => :not_found
  end

  protected

  def preview?
    @preview
  end

  def editing?
    false
  end

  def fetch_page
    @page = Page.by_code(key)
    render('forbidden', :status => :not_found) and return if @page.blank?
  end

  def page
    @page
  end

  def key
    params[:key]
  end
end
