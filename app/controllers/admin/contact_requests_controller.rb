class Admin::ContactRequestsController < Admin::BaseController
  def show
    ariane.add "Received on #{resource.created_at.stamp(configatron.datetime_formats.default)}", admin_contact_request_path(resource)
  end
end
