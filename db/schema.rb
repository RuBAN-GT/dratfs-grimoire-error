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

ActiveRecord::Schema.define(version: 20170330131800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_translations", force: :cascade do |t|
    t.integer  "card_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.string   "intro"
    t.text     "description"
    t.index ["card_id"], name: "index_card_translations_on_card_id", using: :btree
    t.index ["locale"], name: "index_card_translations_on_locale", using: :btree
  end

  create_table "cards", force: :cascade do |t|
    t.string   "real_id",                      null: false
    t.string   "full_picture"
    t.string   "mini_picture"
    t.integer  "collection_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "replacement",   default: true
    t.boolean  "glossary",      default: true
    t.index ["collection_id"], name: "index_cards_on_collection_id", using: :btree
    t.index ["real_id"], name: "index_cards_on_real_id", using: :btree
  end

  create_table "collection_translations", force: :cascade do |t|
    t.integer  "collection_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
    t.index ["collection_id"], name: "index_collection_translations_on_collection_id", using: :btree
    t.index ["locale"], name: "index_collection_translations_on_locale", using: :btree
  end

  create_table "collections", force: :cascade do |t|
    t.string   "real_id",      null: false
    t.string   "full_picture"
    t.string   "mini_picture"
    t.integer  "theme_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["real_id"], name: "index_collections_on_real_id", using: :btree
    t.index ["theme_id"], name: "index_collections_on_theme_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "slug",       null: false
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_roles_on_slug", using: :btree
  end

  create_table "theme_translations", force: :cascade do |t|
    t.integer  "theme_id",   null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.index ["locale"], name: "index_theme_translations_on_locale", using: :btree
    t.index ["theme_id"], name: "index_theme_translations_on_theme_id", using: :btree
  end

  create_table "themes", force: :cascade do |t|
    t.string   "real_id",      null: false
    t.string   "full_picture"
    t.string   "mini_picture"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["real_id"], name: "index_themes_on_real_id", using: :btree
  end

  create_table "tooltips", force: :cascade do |t|
    t.string   "slug",                        null: false
    t.string   "body",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "replacement", default: false
    t.index ["slug"], name: "index_tooltips_on_slug", using: :btree
  end

  create_table "user_cards", primary_key: ["user_id", "card_id"], force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "card_id", null: false
    t.index ["card_id"], name: "index_user_cards_on_card_id", using: :btree
    t.index ["user_id"], name: "index_user_cards_on_user_id", using: :btree
  end

  create_table "user_roles", primary_key: ["user_id", "role_id"], force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id", using: :btree
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid",                                           null: false
    t.string   "membership_id",                                 null: false
    t.string   "membership_type",                 default: "2", null: false
    t.string   "display_name",                                  null: false
    t.string   "remember_token",      limit: 150
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["membership_id"], name: "index_users_on_membership_id", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
    t.index ["uid"], name: "index_users_on_uid", using: :btree
  end

end
