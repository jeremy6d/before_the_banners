class DatepickerInput < SimpleForm::Inputs::Base
  def input
    @builder.text_field(attribute_name, input_html_options.merge(name: nil)) + \
    @builder.hidden_field(attribute_name, { :class => attribute_name.to_s + "-alt", 
      id: "#{attribute_name}-alt"})
  end
end