class ChippdProductTypeTable < AdminTable
  column :image do |object, view|
    view.image_tag((object.image_uid.present? ? object.image.remote_url : 'http://quickimage.it/50&text=%3F'), :width => 100, :class => "thumbnail")
  end
  column :name
  column :admin_note

  actions do
    action {|object, view| view.link_to_edit(object) }
  end
end