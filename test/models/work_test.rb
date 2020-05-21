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
  
  it "is valid when all fields are present" do
    expect(new_work.valid?).must_equal true
  end

  it "will have all required fields" do
    new_work.save
    work = Work.first

    [:title, :category, :publication_year, :creator, :description]. each do |field|
      expect(work).must_respond_to field
    end
  end

  # Counter Cache
  describe "counter cache" do
    before do
      @work_with_no_votes = works(:leon)
    end

    it "has a default value of 0" do
      assert_equal(0, @work_with_no_votes.votes_count)
    end

    it "changes count when upvotes are added" do 
      expect {
        perform_upvote(users(:schrodinger), works(:leon))
        perform_upvote(users(:einstein), works(:leon))
        perform_upvote(users(:pavlov), works(:leon))
      }.must_differ '@work_with_no_votes.votes_count', 3
    end
  end

  # Relationships
  describe "relationships" do
    before do
      @work_with_no_votes = works(:leon)
      @work_with_votes = works(:tame_impala)

      perform_upvote(users(:rosalind), @work_with_votes)
      perform_upvote(users(:schrodinger), @work_with_votes)
    end

    describe "between work and vote models" do
        it "has a vote instance even when no votes are added" do
          assert_not_nil(@work_with_no_votes.votes)
        end
    
        it "has votes when votes are added" do
          expect(@work_with_votes.votes_count).must_equal 2
        end
    
        it "can have many votes" do
          expect(@work_with_votes.votes_count).must_be :>, 1
          @work_with_votes.votes.each do |vote|
            expect(vote).must_be_instance_of Vote
          end
      end
    end
    
    describe "between work and user models" do
      it "has a user instance even when no votes are added" do
        assert_not_nil(@work_with_no_votes.users)
      end

      it "has a user when a vote is added" do
        expect(@work_with_votes.users.count).must_equal 2
      end

      it "can have many users" do
        expect(@work_with_votes.users.count).must_be :>, 1
        @work_with_votes.users.each do |user|
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
    before do
      # set one work to have highest amount of votes
      @spotlight_work = works(:mahalia)

      users = User.all

      users.each do |user|
        perform_upvote(user, @spotlight_work)
      end
    end

    it "can get a work" do
      work = Work.spotlight
   
      assert_instance_of(Work, work)

      [:title, :category, :publication_year, :creator, :description]. each do |field|
        expect(work).must_respond_to field
      end
    end

    it "gets the work with the highest number of votes" do
      works = Work.all

      expect(Work.spotlight).must_equal @spotlight_work
    end

    it "returns nil if there are no works" do
      # Make local Work database empty
      Work.destroy_all
      
      assert_nil(Work.spotlight)
    end
  end

  # Top Ten
  describe "top ten method" do
    before do
      # Albums
      @top_ten_albums_test = [
        works(:banks), 
        works(:lemaitre), 
        works(:ariana_grande), 
        works(:arctic_monkeys),
        works(:mahalia),
        works(:lianne_la_havas),
        works(:tame_impala),
        works(:leon),
        works(:the_strokes),
        works(:foster_the_people)
        ]

      number_of_upvotes = 20

      @top_ten_albums_test.each do |work|
        number_of_upvotes.times do
          perform_upvote(users(:einstein), work)
        end
        number_of_upvotes -= 2
      end

      # Movies
      @top_three_movies_test = [
        works(:interstellar),
        works(:pride_and_prejudice),
        works(:zoolander)
      ]
    end

    it "gets the correct top ten works for a category" do
      album_list = Work.top_ten("album")
      assert_equal(@top_ten_albums_test, album_list)
    end

    it "can get a list of 10 works and they are all in the same category" do
      album_list = Work.top_ten("album")
      expect(album_list.length).must_equal 10

      album_list.each do |album|
        expect(album.category).must_equal "album"
      end
    end

    it "deals with tiebreaks by sorting alphabetically" do
      movie_list = Work.top_ten("movie")
      assert_equal(@top_three_movies_test, movie_list)
    end

    it "will return nil if there are no works" do
      # Make local Work database empty
      Work.destroy_all

      assert_nil(Work.top_ten("album"))
    end

    it "will return the same amount of items as the amount of works if the total amount of works is less than 10" do
      movie_list = Work.top_ten("movie")
      expect(movie_list.length).must_equal 3
    end
  end

  # Sorted Media Method
  describe "sorted media method" do
    before do
      @movies_list = [
        works(:zoolander),
        works(:interstellar),
        works(:pride_and_prejudice)
      ]

      perform_upvote(users(:einstein), works(:zoolander))
    end

    it "will return nil if there are no works" do
      # Make local Work database empty
      Work.destroy_all

      assert_nil(Work.sorted_media("album"))
    end

    it "gets the same category for the list of works" do
      album_list = Work.sorted_media("album")

      album_list.each do |album|
        expect(album.category).must_equal "album"
      end
    end

    it "provides a list sorted by votes in descending order" do
      2.times do
        perform_upvote(users(:einstein), works(:interstellar))
      end

      expected_sorted_list = [works(:interstellar),  works(:zoolander), works(:pride_and_prejudice)]

      expect(Work.sorted_media("movie")).must_equal expected_sorted_list
    end

    it "deals with tiebreaks by sorting alphabetically" do
      movie_list = Work.sorted_media("movie")
      assert_equal(@movies_list, movie_list)
    end
  end
end
