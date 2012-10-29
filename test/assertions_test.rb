require "test_helper"

class UserToJsonTest < MiniTest::Unit::TestCase
  def setup
    @user = OpenStruct.new id: 42, first_name: "Steve", last_name: "Richert", friends: []
    @names = %({"first_name":"Steve","last_name":"Richert"})
  end

  def test_includes_names
    assert_must be_json_eql(@names).excluding("friends"), @user.to_json
  end

  def test_includes_id
    assert_have_json_path @user.to_json, "id"
    assert_must have_json_path("id"), @user.to_json

    assert_must have_json_type(Integer).at_path("id"), @user.to_json
  end

  def test_includes_friends
    assert_must have_json_size(0).at_path("friends"), @user.to_json

    friend = OpenStruct.new first_name: "Catie", last_name: "Richert"
    @user.friends << friend

    assert_must have_json_size(1).at_path("friends"), @user.to_json
    assert_must include_json(friend.to_json).at_path("friends"), @user.to_json
  end
end
