class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.string :real_id, :null => false, :index => true

      t.string :full_picture
      t.string :mini_picture

      t.references :theme, :index => true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Collection.create_translation_table! :name => :string
      end

      dir.down do
        Collection.drop_translation_table!
      end
    end
  end
end
