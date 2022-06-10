stripe_config = YAML.load(ERB.new(File.new(Rails.root.join('config/stripe.yml')).read).result)[Rails.env]
configatron.stripe.secret_key = stripe_config["secret_key"]
configatron.stripe.publishable_key = stripe_config["publishable_key"]

Stripe.api_key = configatron.stripe.secret_key
