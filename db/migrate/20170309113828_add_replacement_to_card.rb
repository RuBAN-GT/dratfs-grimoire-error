class AddReplacementToCard < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :replacement, :boolean, :default => true
  end
end
