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

ActiveRecord::Schema.define(version: 20171226133425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "debts", force: :cascade do |t|
    t.text "from"
    t.text "to"
    t.integer "amount"
    t.string "desc"
    t.text "state"
    t.text "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paid_at"
    t.text "paid_by"
    t.text "chat_id"
    t.index ["chat_id", "state"], name: "index_debts_on_chat_id_and_state"
    t.index ["from", "state"], name: "index_debts_on_from_and_state"
    t.index ["to", "state"], name: "index_debts_on_to_and_state"
  end

end
