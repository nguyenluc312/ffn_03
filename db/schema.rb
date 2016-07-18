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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160716165721) do

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "comments", force: :cascade do |t|
    t.integer  "news_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["news_id"], name: "index_comments_on_news_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "league_seasons", force: :cascade do |t|
    t.integer  "year"
    t.integer  "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "league_seasons", ["league_id"], name: "index_league_seasons_on_league_id"

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "leagues", ["country_id"], name: "index_leagues_on_country_id"

  create_table "match_events", force: :cascade do |t|
    t.integer  "match_id"
    t.text     "content"
    t.integer  "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "match_events", ["match_id"], name: "index_match_events_on_match_id"

  create_table "matches", force: :cascade do |t|
    t.integer  "league_season_id"
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "team1_goal"
    t.integer  "team2_goal"
    t.float    "team1_odds"
    t.float    "team2_odds"
    t.float    "draw_odds"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "status"
  end

  add_index "matches", ["league_season_id"], name: "index_matches_on_league_season_id"

  create_table "news", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "brief_description"
    t.text     "content"
    t.string   "author"
    t.integer  "news_type_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "represent_image"
  end

  add_index "news", ["news_type_id"], name: "index_news_on_news_type_id"
  add_index "news", ["user_id"], name: "index_news_on_user_id"

  create_table "news_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_awards", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "nameLstring"
    t.integer  "league_season_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "player_awards", ["league_season_id"], name: "index_player_awards_on_league_season_id"
  add_index "player_awards", ["player_id"], name: "index_player_awards_on_player_id"

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.text     "introduction"
    t.integer  "position"
    t.integer  "team_id"
    t.datetime "data_of_birth"
    t.string   "avatar"
    t.integer  "country_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "players", ["country_id"], name: "index_players_on_country_id"
  add_index "players", ["team_id"], name: "index_players_on_team_id"

  create_table "season_teams", force: :cascade do |t|
    t.integer  "league_season_id"
    t.integer  "team_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "season_teams", ["league_season_id"], name: "index_season_teams_on_league_season_id"
  add_index "season_teams", ["team_id"], name: "index_season_teams_on_team_id"

  create_table "team_achievements", force: :cascade do |t|
    t.string   "name"
    t.integer  "season_team_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "team_achievements", ["season_team_id"], name: "index_team_achievements_on_season_team_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "country_id"
    t.string   "logo"
    t.text     "introduction"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "teams", ["country_id"], name: "index_teams_on_country_id"

  create_table "user_bets", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "user_id"
    t.integer  "coin"
    t.integer  "chosen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_bets", ["match_id"], name: "index_user_bets_on_match_id"
  add_index "user_bets", ["user_id"], name: "index_user_bets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.integer  "role"
    t.integer  "coin"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
