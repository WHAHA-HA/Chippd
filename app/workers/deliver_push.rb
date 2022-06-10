class DeliverPush < ApiWorker
  def perform(ios_tokens, android_tokens, ios_payload, android_payload)
    notification = {}

    if ios_tokens.present?
      notification[:device_tokens] = ios_tokens
      notification[:aps] = ios_payload
    end

    if android_tokens.present?
      notification[:apids] = android_tokens
      notification[:android] = android_payload
    end

    Urbanairship.push notification
  end
end
