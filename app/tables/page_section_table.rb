class PageSectionTable < TableCloth::Base
  column :type do |object, view|
    object._type
  end
  column :state do |object, view|
    object.respond_to?(:state) ? object.state : ''
  end
  column :job_id do |object, view|
    object.respond_to?(:job_id) ? view.content_tag(:code, object.job_id) : ''
  end
  column :updated_at do |object, view|
    object.updated_at.stamp(configatron.datetime_formats.default)
  end
end
