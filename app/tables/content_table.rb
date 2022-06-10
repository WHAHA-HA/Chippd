class ContentTable < AdminTable
  column :name
  column :location_information, :label => "Page(s) Displayed On" do |object, view|
    ContentPresenter.new(object, view).short_location_information
  end

  actions do
    action {|object, view| view.link_to_edit(object) }
  end
end