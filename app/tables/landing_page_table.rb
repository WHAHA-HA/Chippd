class LandingPageTable < AdminTable
  column :title
  column :images do |object, view|
    view.link_to_collection(object.images.length, view.admin_landing_page_images_path(object))
  end
  column :steps do |object, view|
    view.link_to_collection(object.steps.length, view.admin_landing_page_steps_path(object))
  end
end