require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "database has a unique case insensitive email index" do
    index = ActiveRecord::Base.connection.indexes(:users).find { |item| item.name == "index_users_on_lower_email" }
    assert index
    assert index.unique
  end

  test "password may be one character" do
    user = User.new(name: "Short Password", email: "short@example.com", password: "a")
    assert user.valid?
  end

  test "email is normalized" do
    user = User.create!(name: "Example", email: "  TEST@Example.COM  ", password: "x")
    assert_equal "test@example.com", user.reload.email
  end
end
