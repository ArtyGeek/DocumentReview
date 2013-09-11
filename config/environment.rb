# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Documentreview::Application.initialize!

ActionMailer::Base.default_url_options = { :host => 'artygeek-rails-demo1.heroku.com' }
ActionMailer::Base.default from: 'rails-demo@artygeek.com'


