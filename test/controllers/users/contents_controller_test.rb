require 'test_helper'

class Users::ContentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_contents_index_url
    assert_response :success
  end

  test "should get show" do
    get users_contents_show_url
    assert_response :success
  end

end
