class PickerInput < SimpleForm::Inputs::Base
  def input
    [
      @builder.text_field(attribute_name, input_html_options.merge(default_date_options)),
      template.content_tag('span', template.content_tag('i', '', 'data-time-icon' => "icon-time", 'data-date-icon' => "icon-calendar"), :class => 'add-on')
    ].join.html_safe
  end

  def default_date_options
    { class: "datepicker" }
  end
end