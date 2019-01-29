class CreateCardVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :card_variants do |t|
      t.text :body, :null => false

      t.references :card, :index => true
      t.references :user

      t.timestamps
    end
  end
end
