require "test_helper"

describe Vote do
  let (:new_vote) {
    Vote.new(
      user_id: users(:rosalind).id,
      work_id: works(:interstellar).id
    )
  }
  # Validations
  describe "validations" do  
    it "is valid when all fields are present" do
      expect(new_vote.valid?).must_equal true
    end

    it "is invalid without a user id" do
      new_vote.user_id = nil

      result = new_vote.valid?

      expect(result).must_equal false
      expect(new_vote.errors.messages).must_include :user_id
      expect(new_vote.errors.messages[:user_id]).must_equal ["can't be blank"]
    end

    it "is invalid without a work id" do
      new_vote.work_id = nil

      result = new_vote.valid?

      expect(result).must_equal false
      expect(new_vote.errors.messages).must_include :work_id
      expect(new_vote.errors.messages[:work_id]).must_equal ["can't be blank"]
    end
  end

  # Relationships
  describe "relationships" do
    it "belongs to a user" do
      new_vote.save
      vote = Vote.first

      expect(vote.user.valid?).must_equal true
      expect(vote.user).must_be_instance_of User
    end

    it "belongs to a work" do
      new_vote.save
      vote = Vote.first

      expect(vote.work.valid?).must_equal true
      expect(vote.work).must_be_instance_of Work
    end
  end
end
