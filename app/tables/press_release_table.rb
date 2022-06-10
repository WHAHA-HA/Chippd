class PressReleaseTable < AdminTable
  column :image do |object, view|
    view.image_tag(object.thumb.remote_url, :width => 100, :class => "thumbnail")
  end
  column :title
  column :published_on do |object|
    object.published_on.try(:stamp, configatron.date_formats.short)
  end
end