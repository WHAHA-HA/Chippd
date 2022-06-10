class BatchDetailTable < TableCloth::Base
  column :value do |object, view|
    view.content_tag(:code, object.value)
  end
  column :redeem do |object, view|
    view.content_tag(:code, object.redeem)
  end

  column :used do |object, view|
    view.content_tag(:code, object.used)
  end

  column :redeemed_by do |object, view|
    view.link_to(object.redeemed_by, admin_customer_path(object.redeemed_by)) if object.used
  end
end
