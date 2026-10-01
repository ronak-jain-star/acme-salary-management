class SalaryChange < ApplicationRecord
  belongs_to :employee
  validates :previous_amount_minor, :new_amount_minor, numericality: { only_integer: true, greater_than: 0 }
  validates :currency, :previous_currency, format: { with: /\A[A-Z]{3}\z/ }
  validates :reason, presence: true, length: { maximum: 500 }
  validates :changed_by, presence: true
end
