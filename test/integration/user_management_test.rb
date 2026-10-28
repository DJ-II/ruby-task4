require "test_helper"

class UserManagementTest < ActionDispatch::IntegrationTest
  test "guest cannot view users" do
    get users_path
    assert_redirected_to login_path
  end

  test "user can register with one character password" do
    post register_path, params: { user: { name: "Alice", email: "alice@example.com", password: "a" } }
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_select "table"
  end

  test "blocked user is redirected on next protected request" do
    user = User.create!(name: "Alice", email: "alice@example.com", password: "a")
    post login_path, params: { email: "alice@example.com", password: "a" }
    assert_redirected_to users_path
    user.update!(blocked: true)
    get users_path
    assert_redirected_to login_path
  end

  test "user can block their own account" do
    user = User.create!(name: "Alice", email: "alice@example.com", password: "a")
    post login_path, params: { email: user.email, password: "a" }
    post bulk_users_path, params: { operation: "block", user_ids: [user.id.to_s] }
    assert_redirected_to login_path
    assert user.reload.blocked?
  end

  test "user can delete their own account" do
    user = User.create!(name: "Alice", email: "alice@example.com", password: "a")
    post login_path, params: { email: user.email, password: "a" }
    post bulk_users_path, params: { operation: "delete", user_ids: [user.id.to_s] }
    assert_redirected_to login_path
    assert_nil User.find_by(id: user.id)
  end
end
