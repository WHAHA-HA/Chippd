class PushNotification
  attr_accessor :ios_tokens, :android_tokens, :ios_payload, :android_payload

  def self.deliver(devices, message, options = {})
    notification = self.new(devices, message, options)
    notification.deliver
  end

  def initialize(devices, message, options = {})
    @ios_tokens = devices.select { |d| !(d.platform.upcase =~ /ANDROID/) }.collect { |d| d.push_token }.compact
    @android_tokens = devices.select { |d| d.platform.upcase =~ /ANDROID/ }.collect { |d| d.push_token }.compact
    @ios_payload = {}
    @ios_payload[:alert] = message
    @ios_payload[:sound] = options[:sound] || "default"
    @ios_payload[:badge] = options[:badge] || 1
    @ios_payload[:pageId] = options[:page_id] if options[:page_id]
    @android_payload = {}
    @android_payload[:alert] = message
    @android_payload[:extra] = { :pageId => options[:page_id] } if options[:page_id]
  end

  def deliver
    DeliverPush.perform_async(self.ios_tokens, self.android_tokens, self.ios_payload, self.android_payload)
  end
end
