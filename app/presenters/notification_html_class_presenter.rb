# Takes a key (from Rails' flash object most likely)
# and checks if we want to map it to a custom class name.
# We do this to map Rails' flash keys to Bootstrap's
# notification classes.
class NotificationHtmlClassPresenter
  def initialize(key)
    @key = key
  end

  def map
    {
      :alert => 'alert-error',
      :notice => 'alert-info',
      :error => 'alert-error'
    }
  end

  def mapping
    map.fetch(@key, nil)
  end

  def to_html_class
    ['alert', mapping].compact.join(' ')
  end
end