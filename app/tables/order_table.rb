class OrderTable < AdminTable
  column :number do |object, view|
    view.content_tag(:code, object.number)
  end
  column :name do |object, view|
    object.customer.try(:full_name)
  end
  column :email do |object, view|
    object.customer.try(:email)
  end
  column :state do |object, view|
    object.state
  end
  column :gift do |object, view|
    object.is_gift
  end
  column :date do |object, view|
    view.render(:partial => 'timestamp', :locals => { :order => object })
  end

  actions do
    action {|object, view| view.link_to_edit(object) }
  end
end