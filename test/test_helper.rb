require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
    # Log in as a particular user.
  def log_in_as(user, password: 'test_password')
      post login_path, params: {
        session: {
          email: user.email,
          password: password,
        }
      }
  end

end
