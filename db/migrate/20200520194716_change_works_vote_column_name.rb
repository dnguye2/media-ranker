class ChangeWorksVoteColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :works, :vote_count, :votes_count
  end
end
