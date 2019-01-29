class AddGlossaryToCard < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :glossary, :boolean, :default => true
  end
end
