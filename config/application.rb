require_relative 'boot'

require 'csv' 
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyJira
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.action_mailer.asset_host = 'my-jira-heroku.herokuapp.com'
    config.action_mailer.preview_path = "#{Rails.root}/test/mailers/previews"
    config.action_mailer.smtp_settings = {
     :address              => 'smtp.gmail.com',
     :port                 => 587,
     :domain               => 'gmail.com',
     :user_name            => 'myjirateam@gmail.com',
     :password             => 'COSI166bMyJira',
     :authentication       => 'login',
     :enable_starttls_auto => true
   }
  end
end
