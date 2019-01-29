class CreateErrorMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :error_messages do |t|
      t.string :url, :null => false, :index => true
      t.string :context, :null => false
      t.string :user_ip, :null => false

      t.timestamps
    end
  end
end
