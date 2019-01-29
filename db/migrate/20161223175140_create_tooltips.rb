class CreateTooltips < ActiveRecord::Migration[5.0]
  def change
    create_table :tooltips do |t|
      t.string :slug, :null => false, :index => true
      t.string :body, :null => false

      t.timestamps
    end
  end
end
