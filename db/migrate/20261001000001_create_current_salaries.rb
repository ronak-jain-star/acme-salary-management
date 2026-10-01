class CreateCurrentSalaries < ActiveRecord::Migration[7.1]
  def change
    return if table_exists?(:current_salaries)

    create_table :current_salaries do |t|
      t.references :employee, null: false, foreign_key: true, index: { unique: true }
      t.integer :amount_minor, null: false
      t.string :currency, null: false, limit: 3
      t.timestamps
    end
    add_index :current_salaries, %i[currency amount_minor]
  end
end
