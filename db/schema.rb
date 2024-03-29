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

ActiveRecord::Schema.define(:version => 20120508181546) do

  create_table "links", :force => true do |t|
    t.integer  "search_id"
    t.string   "url"
    t.integer  "frequency"
    t.string   "sources"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "moderation_status"
    t.datetime "first_tweeted"
  end

  create_table "searches", :force => true do |t|
    t.string   "query"
    t.string   "last_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "featured_link_id"
    t.boolean  "active",           :default => false
    t.string   "category",         :default => "Search"
  end

end
