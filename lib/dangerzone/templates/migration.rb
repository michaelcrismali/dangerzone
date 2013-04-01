class CreateUsersTableViaDangerzone < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string   :email
      t.string   :password
      t.string   :password_confirmation
      t.string   :password_digest
      t.string   :sign_in_ip
      t.string   :remember_token
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean  :confirmed,              :default => false
      t.integer  :sign_in_count,          :default => 0

      t.timestamps
    end
  end

  def down
    drop_table :users
  end

end
