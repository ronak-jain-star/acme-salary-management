class CreatePayrollTables < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :employee_number, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :country, null: false
      t.string :department, null: false
      t.string :title, null: false
      t.timestamps
    end
    add_index :employees, :employee_number, unique: true
    add_index :employees, %i[country department]
    create_table :current_salaries do |t|
      t.references :employee, null: false, foreign_key: true, index: { unique: true }
      t.integer :amount_minor, null: false
      t.string :currency, null: false, limit: 3
      t.timestamps
    end
    add_index :current_salaries, %i[currency amount_minor]
    create_table :salary_changes do |t|
      t.references :employee, null: false, foreign_key: true
      t.integer :previous_amount_minor, null: false
      t.string :previous_currency, null: false, limit: 3
      t.integer :new_amount_minor, null: false
      t.string :currency, null: false, limit: 3
      t.string :reason, null: false, limit: 500
      t.string :changed_by, null: false
      t.timestamps
    end
    add_index :salary_changes, %i[employee_id created_at]
  end
end
