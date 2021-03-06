# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090317045501) do

  create_table "amounts", :force => true do |t|
    t.string   "ing_amnt"
    t.integer  "ingredient_id"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ing_group",     :default => "Main"
  end

  create_table "ingredients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.string   "author"
    t.text     "directions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner"
    t.string   "picture_url"
  end

  create_table "sessions", :force => true do |t|
    t.string   "token"
    t.string   "logged_in"
    t.string   "ip_addr"
    t.string   "session_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "lock"
    t.string   "salt"
    t.string   "encrypted_password"
    t.string   "login"
  end

end
