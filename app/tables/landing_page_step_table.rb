class LandingPageStepTable < AdminTable
  column :number do |object, view|
    view.content_tag(:span, object.number, :class => 'badge')
  end
  column :image do |object, view|
    view.image_tag(object.image.remote_url, :class => "thumbnail span2")
  end
  column :title
end
