# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Documentreview::Application.initialize!

ActionMailer::Base.default_url_options = { :host => 'artygeek-rails-demo1.heroku.com' }
ActionMailer::Base.default from: 'rails-demo@artygeek.com'
ActionMailer::Base.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV["DOMAIN_NAME"],
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
  }

