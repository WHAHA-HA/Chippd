class MyChippd::ProfilesController < MyChippd::BaseController
  layout "simple"

  def edit
  end

  def update
    if password_changed?
      if current_customer.update_with_password(params[:customer])
        sign_in current_customer, :bypass => true
        redirect_to(edit_my_chippd_profile_url, :notice => "Your profile and password were successfully updated.")
      else
        render 'edit'
      end
    else
      if current_customer.update_without_password(params[:customer])
        redirect_to(edit_my_chippd_profile_url, :notice => "Your profile was successfully updated.")
      else
        render 'edit'
      end
    end
  end

  def destroy
    current_customer.destroy
    sign_out(current_customer)
    redirect_to(root_url, :notice => "Your account has been deleted.")
  end

  protected

  def password_changed?
    params[:customer] && params[:customer][:password].present?
  end
end
