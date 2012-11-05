# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121105080117) do

  create_table "attitudes", :force => true do |t|
    t.integer  "chat_node_id"
    t.integer  "user_id"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_memberships", :force => true do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_nodes", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "chat_id"
    t.string   "content"
    t.string   "kind"
    t.string   "attachment_file_name"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  create_table "chats", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  create_table "commits", :force => true do |t|
    t.integer  "forked_data_list_id"
    t.string   "operation"
    t.string   "seed"
    t.string   "title"
    t.text     "content"
    t.string   "url"
    t.integer  "file_entity_id"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_user_id"
    t.string   "message"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_items", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "url"
    t.integer  "file_entity_id"
    t.string   "kind"
    t.integer  "data_list_id"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seed"
  end

  create_table "data_list_readings", :force => true do |t|
    t.integer  "data_list_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_lists", :force => true do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.string   "kind"
    t.boolean  "public",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",          :default => true,  :null => false
    t.integer  "forked_from_id"
  end

  create_table "file_entities", :force => true do |t|
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.string   "uuid"
    t.integer  "creator_id"
    t.text     "content"
    t.string   "kind"
    t.boolean  "is_removed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.datetime "attachment_updated_at"
  end

  create_table "online_records", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_records", ["key"], :name => "index_online_records_on_key"
  add_index "online_records", ["user_id"], :name => "index_online_records_on_user_id"

  create_table "slice_temp_files", :force => true do |t|
    t.integer  "creator_id"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "path"
    t.integer  "saved_size"
    t.integer  "saved_blob_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :default => "", :null => false
    t.string   "hashed_password",           :default => "", :null => false
    t.string   "salt",                      :default => "", :null => false
    t.string   "email",                     :default => "", :null => false
    t.string   "sign"
    t.string   "activation_code"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "activated_at"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.datetime "last_login_time"
    t.boolean  "send_invite_email"
    t.integer  "reputation",                :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "data_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
