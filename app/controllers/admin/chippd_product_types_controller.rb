class Admin::ChippdProductTypesController < Admin::BaseController
  protected

  def plural_resource
    "Settings"
  end

  def singular_resource
    "Setting"
  end
end
