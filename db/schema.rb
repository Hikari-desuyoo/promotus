# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_05_03_180648) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discord_users", force: :cascade do |t|
    t.bigint "discord_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "factions", force: :cascade do |t|
    t.bigint "guild_id", null: false
    t.bigint "title_role_id"
    t.bigint "root_role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guild_id"], name: "index_factions_on_guild_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "discord_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "guild_id", null: false
    t.bigint "discord_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discord_user_id"], name: "index_memberships_on_discord_user_id"
    t.index ["guild_id"], name: "index_memberships_on_guild_id"
  end

  create_table "role_branches", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "child_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "faction_id"
    t.string "name"
    t.bigint "discord_id"
    t.integer "faction_degree"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["faction_id"], name: "index_roles_on_faction_id"
  end

  add_foreign_key "factions", "guilds"
  add_foreign_key "memberships", "discord_users"
  add_foreign_key "memberships", "guilds"
  add_foreign_key "roles", "factions"
end
