require 'test_helper'

class ShopsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get shops_edit_url
    assert_response :success
  end

  test "should get update" do
    get shops_update_url
    assert_response :success
  end

end
