class CreateAmounts < ActiveRecord::Migration
  def self.up
    create_table :amounts do |t|
      t.string :ing_amnt
      t.integer :ingredient_id
      t.integer :recipe_id

      t.timestamps
    end
  end

  def self.down
    drop_table :amounts
  end
end
