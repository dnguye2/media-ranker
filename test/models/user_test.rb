require "test_helper"

describe User do
  # Instantiation
  let (:new_user) {
    User.new(
      username: "johannes_kelper"
      )
  }
  
  it "can be instantiated" do
    expect(new_user.valid?).must_equal true
  end

  it "will have all required fields" do
    new_user.save
    user = User.first

    [:username]. each do |field|
      expect(user).must_respond_to field
    end
  end
end
