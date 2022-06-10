module AdminHelper
  def markdown_url
    'http://daringfireball.net/projects/markdown/syntax'
  end

  def make_sortable(id, path)
    render :partial => '/admin/shared/make_sortable', :locals => { :id => id, :path => path }
  end
  safe_helper :make_sortable if respond_to? :safe_helper

  def toggle_visibility_text(object)
    object.is_visible ? "Hide" : "Show"
  end

  def link_to_toggle_visibility(object)
    link_to(toggle_visibility_text(object), toggle_visibility_resource_path(object), :method => :put, :class => 'btn')
  end

  def link_to_edit(object)
    link_to('Edit', edit_resource_path(object), :class => 'btn')
  end

  def link_to_destroy(object)
    link_to('Destroy', resource_path(object), :method => :delete, :class => "btn btn-destroy")
  end

  def is_visible_radio_buttons(form)
    form.input :is_visible, :as => :radio_buttons, :label => "Visible?", :collection => [["Yes", true], ["No", false]]
  end
  safe_helper :is_visible_radio_buttons if respond_to? :safe_helper

  def nav_link_to(text, url, active_matches, match_against = controller.controller_name, options = {})
    content_tag(:li, link_to(text, url, { :title => text }), is_active?(match_against, active_matches))
  end

  # Public: Displays count in a badge and links directly to path
  def link_to_collection(count, path)
    link_to(raw(%{<span class="badge badge-info">#{count}</span>}), path)
  end
end