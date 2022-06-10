class PageSection
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility
  include Mongoid::Orderable

  embedded_in :page

  orderable

  default_scope order_by(:position.asc)

  set_callback(:save, :after) do |document|
    document.page.track_storage_used!
  end

  def implemented?
    true
  end

  def post_initialization_routine
    true
  end

  def symbolized_type
    self._type.underscore.to_sym
  end

  def upload_enabled?
    false
  end

  def uses_storage?
    false
  end

  def storage_used
    0
  end
end
