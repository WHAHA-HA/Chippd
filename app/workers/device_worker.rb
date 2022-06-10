class DeviceWorker < ApiWorker

  def perform(customer_id, headers)
    customer = Customer.find(customer_id)
    device = customer.devices.find_or_create_by(:uuid => headers['device_identifier'])
    device.platform = headers['device_platform']
    device.push_token = headers['device_push_token']
    if device.changed.include?("push_token")
      device.push_token_updated_at = Time.now
      Urbanairship.register_device device.push_token
    end
    device.save
  end
end