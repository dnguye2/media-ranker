require "test_helper"

describe User do
  # Instantiation
  let (:new_user) {
    User.new(
      username: "johannes_kelper"
      )
  }

  it "will have all required fields" do
    new_user.save
    user = User.first

    [:username]. each do |field|
      expect(user).must_respond_to field
    end
  end

  # Counter Cache
  describe "counter cache" do
    before do
      @user_with_no_votes = users(:rosalind)
    end

    it "has a default value of 0" do
      assert_equal(0, @user_with_no_votes.votes_count)
    end

    it "changes count when upvotes are added" do 
      expect {
        perform_upvote(@user_with_no_votes, works(:leon))
        perform_upvote(@user_with_no_votes, works(:the_strokes))
      }.must_differ '@user_with_no_votes.votes_count', 2
    end
  end

  # Relationships
  describe "relationships" do
    before do
      @user_with_no_votes = users(:schrodinger)
      @user_with_votes = users(:pavlov)

      perform_upvote(users(:pavlov), works(:tame_impala))
      perform_upvote(users(:pavlov), works(:bea_miller))
    end

    describe "has many votes" do
        it "has a vote instance even when no votes are added" do
          assert_not_nil(@user_with_no_votes.votes)
        end
    
        it "has votes when votes are added" do
          expect(@user_with_votes.votes_count).must_equal 2
          expect(@user_with_votes.votes.count).must_equal 2
        end
    
        it "can have many votes" do
          expect(@user_with_votes.votes_count).must_be :>, 1
          @user_with_votes.votes.each do |vote|
            expect(vote).must_be_instance_of Vote
          end
        end
    end
  end

  # Validations
  describe "validations" do
    let (:new_user) {
      User.new(
        username: "johannes_kelper"
        )
    }
    
    before do
      @user = users(:einstein)
    end

    it "is valid when all fields are present" do

      expect(new_user.valid?).must_equal true
    end

    it "is invalid without a username" do
      @user.username = nil

      result = @user.valid?

      expect(result).must_equal false
      expect(@user.errors.messages).must_include :username
      expect(@user.errors.messages[:username]).must_equal ["can't be blank"]
    end
  end
end
