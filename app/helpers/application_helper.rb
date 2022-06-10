module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def link_to_top(top = 'branding')
    link_to('&uarr; Back to Top'.html_safe, { :anchor => top })
  end

  def resource_name
    @resource_name ||= :customer
  end

  def resource
    @resource ||= Customer.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:customer]
  end

  # No-Op method to ignore bits that we're not releasing yet.
  def noop(&block)
  end

  def stat_holder(args, options = {})
    tag_options = { :class => 'stat-holder', 'data-args' => args }
    if options[:now]
      tag_options['data-load-now'] = 'true' 
    end
    content_tag :span, 'Loading...', tag_options
  end
end
