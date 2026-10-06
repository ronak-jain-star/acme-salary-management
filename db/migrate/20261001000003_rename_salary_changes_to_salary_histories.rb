class RenameSalaryChangesToSalaryHistories < ActiveRecord::Migration[7.1]
  def change
    rename_table :salary_changes, :salary_histories
  end
end
