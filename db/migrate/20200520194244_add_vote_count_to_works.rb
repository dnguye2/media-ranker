class AddVoteCountToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :vote_count, :integer
  end
end
