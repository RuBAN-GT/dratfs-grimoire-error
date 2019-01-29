class AddGlossaryAndReplacementToTooltip < ActiveRecord::Migration[5.0]
  def change
    add_column :tooltips, :replacement, :boolean, :default => false
  end
end
