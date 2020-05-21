class ChangeUsersDefaultValueForVotesCount < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :votes_count, 0
  end
end
