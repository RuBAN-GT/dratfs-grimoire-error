class DropErrorsAndCardVariantsTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :error_messages
    drop_table :card_variants
  end
end
