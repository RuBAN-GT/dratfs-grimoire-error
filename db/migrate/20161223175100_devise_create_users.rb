class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      # bungie oauth
      t.string :uid, :null => false, :index => true
      t.string :membership_id, :null => false, :index => true
      t.string :membership_type, :null => false, :default => '2'
      t.string :display_name, :null => false

      # rememberable
      t.string :remember_token, :limit => 150, :index => true
      t.datetime :remember_created_at

      # trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps null: false
    end
  end
end
