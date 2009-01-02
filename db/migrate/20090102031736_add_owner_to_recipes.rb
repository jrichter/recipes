class AddOwnerToRecipes < ActiveRecord::Migration
  def self.up
    change_table :recipes do |t|
      t.string :owner      
    end
  end

  def self.down
    change_table :recipes do |t|
      t.remove :owner
    end
  end
end
