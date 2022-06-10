class CrushTablePresenter < ::TableCloth::Presenters::Default
  def render_rows
    v.content_tag :tbody, :id => tbody_id do
      v.raw objects.inject('') {|r, object| r + render_row(object) }
    end
  end

  def render_row(object)
    v.content_tag :tr, row_options(object) do
      v.raw table.columns.inject('') {|tds, (key, column)| tds + render_td(column, object) }
    end
  end

  def render_td(column, object)
    td_options = column.options.delete(:td_options) || {}
    content = column.value(object, view_context, table)
    if column.name == :actions
      content = v.content_tag(:div, content, :class => "btn-group pull-right")
    end
    v.content_tag(:td, content, td_options)
  end

  def render_header
    wrapper_tag :thead do
      wrapper_tag :tr do
        v.raw column_names.inject('') { |tags, name|
          tags + wrapper_tag(:th, (name == "Actions" ? '' : name))
        }
      end
    end
  end

  protected

  def tbody_id
    [self.table_definition.to_s.gsub('Table', '').downcase, 'rows'].join('-')
  end

  def row_options(object)
    options = { :id => v.dom_id(object), :class => v.dom_class(object) }
    if object.respond_to?(:is_visible)
      options[:class] += object.is_visible ? ' visibility-visible' : ' visibility-hidden'
    end
    options
  end
end
