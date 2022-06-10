class AwsPoller

  def initialize(job_section)
    @job_section  = job_section # { :job_id => :section_id }
    @job_ids      = job_section.keys.compact # array of job_ids awaiting transcoding
    @queue_url    = configatron.amazon.sqs_queue_url
    @max_messages = 5
    @wait_time    = 5 # seconds
  end

  def poll_and_handle_messages

    sqs_messages.each do |sqs_message|

      msg    = parsed_message(sqs_message)
      job_id = msg['jobId']

      if @job_ids.include?(job_id)
        section_id = @job_section[job_id]
        section    = Page.find_and_return_section(section_id)
        unless Rails.env.production?
          p "handling AWS message: #{msg.inspect}"
          p "for section: #{section.inspect}"
        end
        post_processing_handler_class(section._type).handle(section, msg)
        delete_message(sqs_message)
      else
        # messages could be delivered more than once... so just delete here
        delete_message(sqs_message) unless Rails.env.development?
      end

    end

  rescue => e
    raise Chippd::PostProcessingError.new(e)
  end

  private

  def sqs_client
    @sqs_client ||= AWS::SQS::Client.new(region: configatron.amazon.region)
  end

  def sqs_messages
    sqs_client.receive_message(
      queue_url: @queue_url,
      max_number_of_messages: @max_messages,
      wait_time_seconds: @wait_time).data[:messages]
  end

  def parsed_message(message)
    JSON.parse(JSON.parse(message[:body])['Message'])
  end

  def delete_message(message)
    sqs_client.delete_message(queue_url: @queue_url,
                              receipt_handle: message[:receipt_handle])
  end

  def post_processing_handler_class(section_type)
    "#{section_type}PostProcessingHandler".constantize
  end

end
