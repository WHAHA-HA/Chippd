class Customers::RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    build_resource

    if resource.save
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_in(resource_name, resource)
      CustomerMailer.welcome(resource.to_param).deliver
      respond_with resource, :location => after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end
