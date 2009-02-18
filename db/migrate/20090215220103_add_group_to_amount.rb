class AddGroupToAmount < ActiveRecord::Migration
  def self.up
    change_table :amounts do |t|
      t.string :ing_group, :default => "Main"
    end
  end

  def self.down
    change_table :amounts do |t|
      t.remove :ing_group
    end
  end
end
