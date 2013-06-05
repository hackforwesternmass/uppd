# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130605201625) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "doc_pages", :force => true do |t|
    t.integer  "filing_doc_id"
    t.integer  "pagenumber"
    t.text     "pagetext"
    t.integer  "wordcount"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "filing_docs", :force => true do |t|
    t.integer  "filing_id"
    t.text     "url"
    t.integer  "pagecount"
    t.string   "doctype"
    t.string   "filetype"
    t.string   "sha1hash"
    t.string   "status",     :default => "new"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "fcc_num"
  end

  add_index "filing_docs", ["status"], :name => "index_filing_docs_on_status"

  create_table "filings", :force => true do |t|
    t.integer  "proceeding_id"
    t.string   "filing_type"
    t.datetime "recv_date"
    t.datetime "posting_date"
    t.boolean  "exparte"
    t.string   "author"
    t.string   "lawfirm"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "fcc_num"
    t.boolean  "business_imp"
    t.string   "applicant"
  end

  add_index "filings", ["fcc_num"], :name => "unique_fcc_num", :unique => true

  create_table "locations", :force => true do |t|
    t.integer  "section_id"
    t.string   "state"
    t.string   "county"
    t.string   "twon"
    t.string   "zip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "proceedings", :force => true do |t|
    t.string   "number"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "status",     :default => "Open"
  end

  add_index "proceedings", ["status"], :name => "index_proceedings_on_status"

  create_table "sections", :force => true do |t|
    t.integer  "start_page"
    t.integer  "end_page"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "filing_doc_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
