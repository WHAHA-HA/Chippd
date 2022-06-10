module SiteHelper
  def logo
    options = { :alt => "Chipp'd" }
    options[:class] = content_for(:logo_class) if content_for?(:logo_class)
    image_tag('logo2.png', options)
  end

  def avatar_url
    "https://#{HOST}/avatar.png"
  end

  def media_room_asset_url(path)
    "https://d2kuoj0xiclrfk.cloudfront.net/#{path}"
  end

  def android_application_url
    "https://play.google.com/store/apps/details?id=com.chippd.qrreader"
  end

  def ios_application_url
    "https://itunes.apple.com/us/app/chippd/id570739404"
  end

  def notifications(wrap_setting = :wrap)
    NotificationPresenter.all(flash, self, wrap_setting)
  end

  def is_active?(cond1, cond2, res = {:class => 'active'})
    empty_result = res.is_a?(Hash) ? {} : ''

    if cond2.is_a?(Array)
      cond2.include?(cond1) ? res : empty_result
    elsif cond2.is_a?(String) || cond2.is_a?(TrueClass) || cond2.is_a?(FalseClass)
      (cond1 == cond2) ? res : empty_result
    else
      empty_result
    end
  end

  def body_class
    classes = []
    classes << controller.controller_name
    classes << "#{controller.controller_name}-#{controller.action_name}"
    classes.join(' ')
  end

  def homepage_product_class(product_collections, product)
    (product_collections.first._id.to_s == product.product_collection_id.to_s) ? 'is-visible' : 'is-hidden'
  end

  def google_analytics_tracking_code(code = 'UA-30693618-1')
    if Rails.env.production?
      code = <<-HERE

    <script>
      var _gaq=[["_setAccount","#{code}"],["_trackPageview"]];
      (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];g.async=1;
      g.src=("https:"==location.protocol?"//ssl":"//www")+".google-analytics.com/ga.js";
      s.parentNode.insertBefore(g,s)}(document,"script"));
    </script>
HERE
      code.html_safe
    end
  end
  def get_satisfaction_code
      code = <<-HERE

    <div id="getsat-widget-791"></div>
    	<script type="text/javascript" src="https://loader.engage.gsfn.us/loader.js"></script>
    	<script type="text/javascript">
if (typeof GSFN !== "undefined") { GSFN.loadWidget(791,{"containerId":"getsat-widget-791"}); }
			</script>
HERE
      code.html_safe
  end

  def sublime_video_javascript_include_tag
    code = <<-HERE

    <script type="text/javascript" src="//cdn.sublimevideo.net/js/o2z63rkw-beta.js"></script>

HERE
    code.html_safe
  end
end
