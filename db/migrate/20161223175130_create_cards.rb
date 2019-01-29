class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :real_id, :null => false, :index => true

      t.string :full_picture
      t.string :mini_picture

      t.references :collection, :index => true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Card.create_translation_table! :name => :string, :intro => :string, :description => :text
      end

      dir.down do
        Card.drop_translation_table!
      end
    end
  end
end
