require "test_helper"

class SignUpTest < ActionDispatch::IntegrationTest
  test "get sign up form and create new user" do
    get "/signup"
    assert_response :success

    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
                                        username: "Lucas",
                                        email: "lucas@lucas.com",
                                        password: "password"
                                      }
                                    }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
  end

  test "get sign up form and reject invalid e-mail" do
    get "/signup"
    assert_response :success

    assert_no_difference 'User.count' do
      post users_path, params: { user: {
                                        username: "Lucas",
                                        email: "lucaslucas.com",
                                        password: "password"
                                      }
                                    }
    end

    assert_match "errors", response.body
    assert_select "div.alert"
    assert_select "h4.alert-heading"
  end
end
