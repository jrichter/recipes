class RemoveOvenTemp < ActiveRecord::Migration
  def self.up
    change_table :recipes do |t|
      t.remove :oven_temp
    end
  end

  def self.down
    change_table :recipes do |t|
      t.integer :oven_temp
    end
  end
end
