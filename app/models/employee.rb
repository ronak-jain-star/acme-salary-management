# frozen_string_literal: true

class Employee < ApplicationRecord
  has_one :current_salary, dependent: :destroy
  has_many :salary_histories, dependent: :restrict_with_exception
  validates :employee_number, :first_name, :last_name, :country, :department, presence: true
  validates :employee_number, uniqueness: true
  scope :search, ->(term) {
    return all if term.blank?
    pattern = "%#{sanitize_sql_like(term.strip)}%"
    where(
      <<~SQL.squish,
        employee_number ILIKE :q OR
        first_name ILIKE :q OR
        last_name ILIKE :q OR
        country ILIKE :q OR
        department ILIKE :q
      SQL
      q: pattern
    )
  }
end
