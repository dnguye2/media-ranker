require "test_helper"

describe Work do
  # Instantiation
  let (:new_work) {
    Work.new(
      title: "The Altar", 
      creator: "BANKS",
      category: "album",
      publication_year: "2016",
      description: "The alt R&B singer-songwriter coaxes universal emotion from her life on an adventurous sophomore album."
      )
  }
  
  it "can be instantiated" do
    expect(new_work.valid?).must_equal true
  end

  it "will have all required fields" do
    new_work.save
    work = Work.first

    [:title, :category, :publication_year, :creator, :description]. each do |field|
      expect(work).must_respond_to field
    end
  end

  # Relationships
  describe "relationships" do
    describe "between work and vote models" do
        it "has a vote instance even when no votes are added" do
          work = works(:leon)
          assert_not_nil(work.votes)
        end
    
        it "has a vote when a vote is added" do
          work = works(:tame_impala)
          vote = Vote.new(user_id: users(:rosalind).id, work_id: work.id)
          vote.save
    
          expect(work.votes.count).must_equal 1
        end
    
        it "can have many votes" do
          work = works(:tame_impala)
    
          users = User.all
    
          users.each do |user|
            vote = Vote.new(user_id: user.id, work_id: work.id)
            vote.save
          end
    
          expect(work.votes.count).must_be :>, 1
          work.votes.each do |vote|
            expect(vote).must_be_instance_of Vote
          end
      end
    end
    
    describe "between work and user models" do
      it "has a user instance even when no votes are added" do
        work = works(:the_strokes)
        assert_not_nil(work.users)
      end

      it "has a user when a vote is added" do
        work = works(:tame_impala)
        vote = Vote.new(user_id: users(:rosalind).id, work_id: work.id)
        vote.save
  
        expect(work.users.count).must_equal 1
      end

      it "can have many users" do
        work = works(:tame_impala)
  
        users = User.all
  
        users.each do |user|
          vote = Vote.new(user_id: user.id, work_id: work.id)
          vote.save
        end
  
        expect(work.users.count).must_be :>, 1
        work.users.each do |user|
          expect(user).must_be_instance_of User
        end
      end
    end
  end

  # Validations
  describe "validations" do
    before do
      @work = works(:banks)
    end

    it "is invalid without a title" do
      @work.title = nil

      result = @work.valid?

      expect(result).must_equal false
      expect(@work.errors.messages).must_include :title
      expect(@work.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "is invalid without a creator" do
      @work.creator = nil

      result = @work.valid?

      expect(result).must_equal false
      expect(@work.errors.messages).must_include :creator
      expect(@work.errors.messages[:creator]).must_equal ["can't be blank"]
    end

    it "is invalid without a category" do
      @work.category = nil

      result = @work.valid?

      expect(result).must_equal false
      expect(@work.errors.messages).must_include :category
      expect(@work.errors.messages[:category]).must_equal ["can't be blank"]
    end

    it "is invalid without a publication year" do
      @work.publication_year = nil

      result = @work.valid?

      expect(result).must_equal false
      expect(@work.errors.messages).must_include :publication_year
      expect(@work.errors.messages[:publication_year]).must_equal ["can't be blank"]
    end

    it "is invalid without a description" do
      @work.description = nil

      result = @work.valid?

      expect(result).must_equal false
      expect(@work.errors.messages).must_include :description
      expect(@work.errors.messages[:description]).must_equal ["can't be blank"]
    end
  end

  # Spotlight
  describe "spotlight method" do
    it "can get a work" do
      work = Work.spotlight()
   
      assert_instance_of(Work, work)

      [:title, :category, :publication_year, :creator, :description]. each do |field|
        expect(work).must_respond_to field
      end
    end

    it "returns nil if there are no works" do
      works = Work.all

      # Make local Work database empty
      works.each do |work|
        work.destroy
      end
      
      expect(Work.spotlight).must_equal nil

    end
  end

  # Top Ten
  describe "top ten method" do
    it "can get a list of 10 works and they are all in the same category" do
      album_list = Work.top_ten("album")
      expect(album_list.length).must_equal 10

      album_list.each do |album|
        expect(album.category).must_equal "album"
      end
    end

    it "will return nil if there are no works" do
      # Make local Work database empty
      Work.destroy_all

      album_list = Work.top_ten("album")
      expect(album_list).must_equal nil
    end

    it "will return the same amount of items as the amount of works if the total amount of works is less than 10" do
      movie_list = Work.top_ten("movie")
      expect(movie_list.length).must_equal 3
    end
  end
end
