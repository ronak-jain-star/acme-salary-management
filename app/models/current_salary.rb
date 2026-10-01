# frozen_string_literal: true

class CurrentSalary < ApplicationRecord
  belongs_to :employee
  validates :amount_minor, numericality: { only_integer: true, greater_than: 0 }
  validates :currency, inclusion: { in: ->(_) { SalarySettings.supported_currencies } }
end
