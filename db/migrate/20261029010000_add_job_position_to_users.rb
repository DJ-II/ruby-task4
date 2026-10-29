class AddJobPositionToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :job_position, :string
    add_index :users, :last_activity_at
  end
end
