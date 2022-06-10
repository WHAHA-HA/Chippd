class DateInput < SimpleForm::Inputs::Base
  def input
    "#{@builder.text_field(attribute_name, input_html_options)} %".html_safe
  end

  def default_date_options
    { :class => "date" }
  end
end