class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    return if table_exists?(:employees)

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
  end
end
