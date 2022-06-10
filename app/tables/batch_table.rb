class BatchTable < TableCloth::Base
  column :number do |object, view|
    view.content_tag(:code, object.number)
  end
  column :code_count, :label => "Total Codes"
  column :codes_used, :label => "Codes Used" do |object, view|
    "#{object.codes_used} (#{view.number_to_percentage(object.percentage_used, :precision => 1)})"
  end
  column :created_at do |object, view|
    object.created_at.stamp(configatron.datetime_formats.default)
  end
  column :retail, :label => "" do |object, view|
    if object.retail
      view.content_tag(:span, 'retail', :class => 'badge badge-info')
    end
  end
  column :product, :label => "" do |object, view|
    if object.retail
      view.render('product_column', :batch => object)
    end
  end

  column :notes

  actions do
    action {|object, view| view.link_to('View', admin_batch_path(object), :class => 'btn') }
    action {|object, view| view.link_to('Download Manifest', object.file.remote_url, :class => 'btn') if object.fully_generated? && object.file.present? }
  end
end