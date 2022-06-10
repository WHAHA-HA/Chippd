class NotificationPresenter
  def self.all(collection, template, wrap_setting = :wrap)
    unless collection.empty?
      notifications = template.content_tag(:div, :class => 'notifications') do
        collection.collect do |key, message|
          template.concat(new(key, message, template).to_html)
        end
      end

      if wrap_setting == :wrap
        template.content_tag(:div, :class => 'container notifications') do
          template.concat(template.content_tag(:div, notifications, :class => 'block'))
        end
      else
        notifications
      end
    end
  end

  def initialize(key, message, template)
    @key = key
    @message = message
    @template = template
  end

  def to_html
    @template.content_tag(:div, :class => NotificationHtmlClassPresenter.new(@key).to_html_class) do
      @template.concat(@template.link_to('x', '#', :class => 'close', 'data-dismiss' => 'alert'))
      @template.concat(@message)
    end
  end
end