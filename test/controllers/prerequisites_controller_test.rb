require 'test_helper'

class PrerequisitesControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get prerequisites_add_url
    assert_response :success
  end

end
