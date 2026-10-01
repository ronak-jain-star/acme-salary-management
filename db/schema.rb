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

ActiveRecord::Schema[7.1].define(version: 2026_10_01_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "current_salaries", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.integer "amount_minor", null: false
    t.string "currency", limit: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency", "amount_minor"], name: "index_current_salaries_on_currency_and_amount_minor"
    t.index ["employee_id"], name: "index_current_salaries_on_employee_id", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_number", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "country", null: false
    t.string "department", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country", "department"], name: "index_employees_on_country_and_department"
    t.index ["employee_number"], name: "index_employees_on_employee_number", unique: true
  end

  create_table "salary_changes", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.integer "previous_amount_minor", null: false
    t.string "previous_currency", limit: 3, null: false
    t.integer "new_amount_minor", null: false
    t.string "currency", limit: 3, null: false
    t.string "reason", limit: 500, null: false
    t.string "changed_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "created_at"], name: "index_salary_changes_on_employee_id_and_created_at"
    t.index ["employee_id"], name: "index_salary_changes_on_employee_id"
  end

  add_foreign_key "current_salaries", "employees"
  add_foreign_key "salary_changes", "employees"
end
