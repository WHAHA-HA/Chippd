# <rails_root>/lib/simple_form/label_nested_input.rb
module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      # Create a html label with nested input and span (containing label text).
      # Used to encapsulate the html layout required to support 
      # Twitter's Bootstrap checkbox and radio button approach.
      #
      # Example:
      #
      #   <label for="foo">
      #     <input name="foo" type="hidden" value="0" />
      #     <input id="foo" name="foo" type="checkbox" value="1" />
      #     <span>This is the label text</span>
      #   </label>
      #
      #  Note: A bug somewhere between Rails & HAML prevents the use of
      #  a block assignment of the content to the label. So, we are 
      #  just verbosely assigning it inline as a method param.
      #
      def label_nested_input
        @builder.label(label_target, 
                       input + template.content_tag('span', label_text), 
                       label_html_options) 
      end    
    end
  end
end
