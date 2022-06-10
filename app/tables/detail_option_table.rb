class DetailOptionTable < AdminTable
  column :name

  actions do
    action {|object, view| view.link_to_edit(object) }
    action {|object, view| view.link_to_destroy(object) }
  end
end