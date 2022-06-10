class MyChippd::MembershipsController < MyChippd::BaseController
  skip_before_filter :verify_authenticity_token

  def destroy
    page = current_customer.pages.find(params[:page_id])
    if page
      membership = page.memberships.find(params[:id])
      membership.destroy if membership
    end
    redirect_to my_chippd_pages_url
  end

  def toggle_access
    page = current_customer.pages.find(params[:page_id])
    if page
      membership = page.memberships.find(params[:id])
      membership.toggle_access! if membership
    end

    respond_with(@page) do |format|
      format.js { head(:ok) }
      format.html { redirect_to my_chippd_pages_url }
    end
  end
end
