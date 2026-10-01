# frozen_string_literal: true

class Employee < ApplicationRecord
  has_one :current_salary, dependent: :destroy
  has_many :salary_changes, dependent: :restrict_with_exception
  validates :employee_number, :first_name, :last_name, :country, :department, presence: true
  validates :employee_number, uniqueness: true
  scope :search, ->(term) {
    return all if term.blank?
    pattern = "%#{sanitize_sql_like(term.strip)}%"
    where(
      'employee_number LIKE :q OR first_name LIKE :q OR last_name LIKE :q OR country LIKE :q OR department LIKE :q',
      q: pattern
    )
  }
end
