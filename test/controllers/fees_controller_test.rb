require 'test_helper'

class FeesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get fees_edit_url
    assert_response :success
  end

end
