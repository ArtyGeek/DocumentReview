# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Documentreview::Application.initialize!

config.action_mailer.default_url_options[:host] = 'artygeek-rails-demo1.heroku.com'
config.action_mailer.default_from = 'rails-demo@artygeek.com'


