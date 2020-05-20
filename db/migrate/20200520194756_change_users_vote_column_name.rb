class ChangeUsersVoteColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :vote_count, :votes_count
  end
end
