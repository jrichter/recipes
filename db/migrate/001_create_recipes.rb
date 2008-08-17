class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :name
      t.string :author
      t.integer :oven_temp
      t.text :directions

      t.timestamps
    end
  end

  def self.down
    drop_table :recipes
  end
end
