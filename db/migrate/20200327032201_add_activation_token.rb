class AddActivationToken < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activated, :boolean, default: false, null: false
    add_column :users, :activation_token, :string, default: nil
    add_column :users, :activation_token_expires_at, :datetime, default: nil
    add_index :users, :activation_token
  end
end
