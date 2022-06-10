class MyChippd::RsvpResponsesController < MyChippd::BaseController
  skip_before_filter :authenticate_customer!, :only => [:create, :update]

  respond_to :csv, :xlsx, :only => [:index]

  def index
    @yes = rsvp.responses.yes
    @no = rsvp.responses.no
    @not_yet_responded = rsvp.page.members_who_have_not_responded_to(rsvp)
    respond_to do |format|
      format.csv { send_data(@responses.to_csv, :filename => "rsvp-responses-#{Time.now.strftime('%Y%m%d%H%M%S')}.csv") }
      format.xlsx {
        response.headers['Content-Disposition'] = %{attachment; filename="rsvp-responses-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"}
      }
    end
  end

  def create
    rsvp_response = rsvp.responses.find_or_create_by(:customer_id => params[:customer_id])
    if rsvp_response.update_attributes(params[:rsvp_response])
      head :ok
    else
      Rails.logger.info(rsvp_response.errors.inspect)
      head :unprocessable_entity
    end
  end

  def update
    rsvp_response = rsvp.responses.find(params[:id])
    if rsvp_response.update_attributes(params[:rsvp_response])
      head :ok
    else
      Rails.logger.info(rsvp_response.errors.inspect)
      head :unprocessable_entity
    end
  end

  def destroy
    rsvp_response = rsvp.responses.find(params[:id])
    rsvp_response.destroy
    redirect_to edit_my_chippd_page_url(rsvp.page)
  end

  protected

  def rsvp
    @rsvp ||= Page.find_and_return_section(params[:rsvp_id])
  end
end
