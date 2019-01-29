class UserHaveAndBelongToManyCards < ActiveRecord::Migration[5.0]
  def self.up
    create_table :user_cards, :id => false do |t|
      t.references :user
      t.references :card
    end

    execute "ALTER TABLE user_cards ADD PRIMARY KEY (user_id, card_id);"
  end

  def self.down
    drop_table :user_cards
  end
end
