class CreateSalaryChanges < ActiveRecord::Migration[7.1]
  def change
    return if table_exists?(:salary_changes)

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
