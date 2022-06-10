class MyChippd::SectionsController < MyChippd::BaseController
  before_filter :fetch_page

  skip_before_filter :fetch_page, :only => [:download_vcard]
  skip_before_filter :authenticate_customer!, :only => [:download_vcard]

  helper_method :section_type, :partial_name

  def sort
    @page.sections.each do |section|
      if position = params[:page_section].index(section.to_param)
        section.move_to!(position + 1)
      end
    end
    touch_page
    render :nothing => true
  end

  def new
    redirect_to edit_my_chippd_page_url(@page)
  end

  configatron.pages.valid_section_types.each do |section|
    define_method([:new, section].join('_')) do
      policy = PageSectionAvailabilityPolicy.new(@page, section)
      redirect_to edit_my_chippd_page_url(@page) and return unless policy.pass?
      @section = @page.sections.build({}, section.to_s.classify.constantize)
      @section.post_initialization_routine
      render 'new'
    end
  end

  def download_vcard
    @page = Page.find(params[:page_id])
    @section = @page.sections.find(params[:id])
    if section_type.vcard?
      presented_section = VcardPresenter.new(@section, view_context)
      send_data presented_section.to_vcf, :type => "text/x-vcard; charset=utf-8", :filename => presented_section.vcf_filename
    else
      if customer_signed_in?
        redirect_to edit_my_chippd_page_url(@page)
      else
        head :ok
      end
    end
  end

  def create
    service = CreatePageSection.new(@page, params.dup)
    redirect_to edit_my_chippd_page_url(@page) and return unless service.available?

    if service.call
      redirect_to edit_my_chippd_page_url(@page)
    else
      @section = service.section
      render 'new'
    end
  end

  def edit
    @section = @page.sections.find(params[:id])
    @presented_section = "#{@section._type}Presenter".constantize.new(@section, view_context)
  end

  def content
    @section = @page.sections.find(params[:id])
    @presented_section = "#{@section._type}Presenter".constantize.new(@section, view_context)
    render :layout => nil
  end

  def update
    service = UpdatePageSection.new(@page, params.dup)
    if service.call
      redirect_to edit_my_chippd_page_url(@page)
    else
      @section = service.section
      render 'edit'
    end
  end

  def destroy
    @section = @page.sections.find(params[:id])
    @section.destroy
    touch_page
    redirect_to edit_my_chippd_page_url(@page)
  end

  def reset
    ResetPageWorker.perform_async(@page.to_param)
    flash[:message] = "Your page is resetting. Refresh in a minute to see your clean page."
    redirect_to edit_my_chippd_page_url(@page)
  end

  protected

  def fetch_page
    @page = current_customer.pages.find(params[:page_id])
  end

  def section_type
    @section_type || PageSectionTypePresenter.new(@section._type.underscore, PagePresenter.new(@page, view_context), view_context)
  end

  def partial_name
    @section._type.underscore
  end

  def touch_page
    @page.update_attribute(:updated_at, Time.now.utc)
  end

end
