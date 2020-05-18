class AddCreatorsToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :creator, :string
  end
end
