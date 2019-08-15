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

ActiveRecord::Schema.define(version: 2019_08_10_104554) do

  create_table "custom_expense_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_custom_expense_types_on_deleted_at"
  end

  create_table "daily_invoices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "restaurant_name"
    t.date "date"
    t.integer "amount"
    t.string "bill_image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "lunch_detail_id"
    t.datetime "deleted_at"
    t.boolean "is_prepaid"
    t.index ["deleted_at"], name: "index_daily_invoices_on_deleted_at"
  end

  create_table "expenses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", comment: "latin1_swedish_ci", force: :cascade do |t|
    t.date "date"
    t.integer "user_id"
    t.integer "daily_invoice_id"
    t.boolean "had_lunch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.datetime "deleted_at"
    t.integer "custom_expense_type_id"
    t.integer "amount"
    t.index ["deleted_at"], name: "index_expenses_on_deleted_at"
  end

  create_table "payment_modes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "payment_gateway"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_payments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.float "amount_paid"
    t.string "comment"
    t.date "date"
    t.integer "payment_mode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "cost_of_meal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enable"
    t.integer "amount_to_be_paid"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
