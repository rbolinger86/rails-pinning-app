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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_01_205710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "board_pinners", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_pinners_on_board_id"
    t.index ["user_id"], name: "index_board_pinners_on_user_id"
  end

  create_table "boards", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "followers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_followers_on_follower_id"
    t.index ["user_id"], name: "index_followers_on_user_id"
  end

  create_table "pinnings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "pin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "board_id"
    t.index ["board_id"], name: "index_pinnings_on_board_id"
    t.index ["pin_id"], name: "index_pinnings_on_pin_id"
    t.index ["user_id"], name: "index_pinnings_on_user_id"
  end

  create_table "pins", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.text "text"
    t.string "slug"
    t.integer "category_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.integer "user_id"
    t.index ["category_id"], name: "index_pins_on_category_id"
    t.index ["user_id"], name: "index_pins_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "board_pinners", "boards"
  add_foreign_key "board_pinners", "users"
  add_foreign_key "boards", "users"
  add_foreign_key "followers", "users"
  add_foreign_key "followers", "users", column: "follower_id"
  add_foreign_key "pinnings", "pins"
  add_foreign_key "pinnings", "users"
  add_foreign_key "pins", "users"
end
