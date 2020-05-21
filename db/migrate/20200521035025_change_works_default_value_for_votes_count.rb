class ChangeWorksDefaultValueForVotesCount < ActiveRecord::Migration[6.0]
  def change
    change_column_default :works, :votes_count, 0
  end
end
