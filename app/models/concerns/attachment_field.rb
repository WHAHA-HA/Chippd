module AttachmentField
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
  end

  module ClassMethods
    def attachment_fields(*attachments)
      attachments.each do |attachment|
        attachment_field(attachment)
      end
    end

    def image_attachment_fields(*attachments)
      attachments.each do |attachment|
        attachment_field(attachment)
        field "#{attachment}_format", :type => Symbol
        field "#{attachment}_width", :type => Integer
        field "#{attachment}_height", :type => Integer
      end
    end

    def attachment_field(attachment)
      field "#{attachment}_uid", :type => String
      field "#{attachment}_size", :type => Integer, :default => 0
    end
  end

  protected

  def calculate_storage_used_for(*attrs)
    attrs.collect { |a| self.send("#{a}_size") }.sum
  end
end
