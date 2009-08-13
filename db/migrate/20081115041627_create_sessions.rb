class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :token
      t.string :logged_in
      t.string :ip_addr
      t.string :session_token
      t.timestamps
    end
  end

  def self.down
    drop_table :sessions
  end
end
