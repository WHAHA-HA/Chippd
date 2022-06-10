Rack::Attack.blacklist('block 181.1.9.71') do |req|
  # Request are blocked if the return value is truthy
  '181.1.9.71' == req.ip
end