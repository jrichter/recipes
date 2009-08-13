class AddLoginInfoToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :lock
      t.string :salt
      t.string :encrypted_password     
      t.string :login 
    end  
  end

  def self.down
    change_table :users do |t|
      t.remove :lock
      t.remove :salt
      t.remove :encrypted_password        
      t.remove :login
    end   
  end
end
