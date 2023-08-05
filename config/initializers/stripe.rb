Rails.configuration.stripe = { 
    :publishable_key => ENV["ENTER YOUR STRIPE_PUBLISHABLE_KEY"],
    :secret_key => ENV["ENTER YPUR STRIPE_SECRET_KEY"]
  } 
  Stripe.api_key = Rails.configuration.stripe[:secret_key]