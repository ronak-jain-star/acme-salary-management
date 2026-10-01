class CurrentSalary < ApplicationRecord
  belongs_to :employee
  validates :amount_minor, numericality: { only_integer: true, greater_than: 0 }
  validates :currency, format: { with: /\A[A-Z]{3}\z/ }
end
