require "test_helper"

describe "User", :to_json do
  let(:user)  { OpenStruct.new id: 42, first_name: "Steve", last_name: "Richert", friends: [] }
  let(:names) { %({"first_name":"Steve","last_name":"Richert"}) }
  subject     { user.to_json }

  it "includes names" do
    user.to_json.must be_json_eql(names).excluding("friends")
  end

  it  { must be_json_eql(names).excluding("friends") }
  must { be_json_eql(names).excluding("friends") }

  it "includes the ID" do
    user.to_json.must have_json_path("id")
    user.to_json.must have_json_type(Integer).at_path("id")
  end

  it  { must have_json_path("id") }
  must { have_json_path("id") }

  it  { must have_json_type(Integer).at_path("id") }
  must { have_json_type(Integer).at_path("id") }

  it "includes friends" do
    user.to_json.must have_json_size(0).at_path("friends")

    friend = OpenStruct.new first_name: "Catie", last_name: "Richert"
    user.friends << friend

    user.to_json.must have_json_size(1).at_path("friends")
    user.to_json.must include_json(friend.to_json).at_path("friends")
  end

  it { must have_json_size(0).at_path("friends") }
  must { have_json_size(0).at_path("friends") }
end
