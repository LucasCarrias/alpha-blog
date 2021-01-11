require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: "lucas",
                              email: "lucas@lucas.com",
                              password:"password"
                            )
    sing_in_as(@user)
  end

  test "get new article form and create new article" do
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: "Test Article", description: "Hello, this is a test article" } }
      assert_response :redirect
    end

    follow_redirect!
    assert_response :success
    assert_match "Test Article", response.body
  end


  test "get new article form and reject invalid title" do
    get "/articles/new"
    assert_response :success

    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: " ", description: "Hello, this is a test article" } }
    end

    assert_match "errors", response.body
    assert_select "div.alert"
    assert_select "h4.alert-heading"
  end
end
