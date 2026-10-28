class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :blocked, null: false, default: false
      t.datetime :last_login_at
      t.datetime :last_activity_at
      t.timestamps
    end

    add_index :users, "LOWER(email)", unique: true, name: "index_users_on_lower_email"
    add_index :users, :blocked
    add_index :users, :last_login_at
  end
end
