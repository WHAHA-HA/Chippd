class MyChippd::PagesController < MyChippd::BaseController
  respond_to :js, :only => :update
  before_filter :redirect_if_unsettled_page_decisions_exist, :only => [:index, :edit, :update, :show]
  before_filter :redirect_unless_unsettled_page_decisions_exist, :only => [:chooser, :add_to_or_create]
  helper_method :presented_page_section_types, :preview?, :back_from_preview_path, :editing?

  def index
    @pages = PagePresenter.from_collection(current_customer.pages, view_context)
  end

  def edit
    @page = PagePresenter.new(current_customer.pages.find(params[:id]), view_context)
  end

  def show
    @page = PagePresenter.new(current_customer.pages.find(params[:id]), view_context)
    @preview = true
    render :layout => false
  end

  def update
    @page = current_customer.pages.find(params[:id])
    @page.update_attributes(params[:page])
    respond_with(@page) do |format|
      format.js { (@page.valid? ? head(:ok) : head(422)) }
      format.html { redirect_to edit_my_chippd_page_url(@page) }
    end
  end

  def chooser
    @page_decisions = PageDecisionPresenter.from_collection(current_customer.page_decisions.unsettled, view_context)
  end

  def add_to_or_create
    current_customer.add_to_or_create_page(params[:choice], params[:page_decision_id])
    redirect_to my_chippd_pages_url
  end

  def example
    render :layout => false
  end

  def notify
    page = current_customer.pages.find(params[:id])
    presented_page = PagePresenter.new(page, view_context)
    if page.eligible_for_notification?
      PushNotification.deliver(page.devices, I18n.t("notifications.push.page_updated", :owner => current_customer.full_name, :page_name => page.name), :page_id => page.to_param)
      page.log_notification_time!
      flash[:notice] = "Your notification has been sent!"
    else
      flash[:notice] = "Sorry, you can't send another notification until #{presented_page.eligible_to_notify_next_at}."
    end
    redirect_to edit_my_chippd_page_url(page)
  end

  protected

  def redirect_if_unsettled_page_decisions_exist
    redirect_to chooser_for_my_chippd_pages_url if current_customer.page_decisions.unsettled.present?
  end

  def redirect_unless_unsettled_page_decisions_exist
    redirect_to my_chippd_pages_url if current_customer.page_decisions.unsettled.blank?
  end

  def preview?
    @preview
  end

  def editing?
    action_name == 'edit'
  end

  def presented_page_section_types
    @presented_page_section_types ||= @page.widgets.collect { |widget| PageSectionTypePresenter.new(widget.type, @page, view_context) }
  end

  def back_from_preview_path
    edit_my_chippd_page_path(@page)
  end
end
