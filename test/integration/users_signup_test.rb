# $ rails generate integration_test users_signup
# Tests:
# 1 - invalid user doesn't get saved
# 2 - valid user gets saved

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    # to make sure if the signup is invalid it doesn't get saved ->
    # so the amount of the useres are the same: with count
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'  # to make sure it posts to the custome url, not the default 'users' url
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
