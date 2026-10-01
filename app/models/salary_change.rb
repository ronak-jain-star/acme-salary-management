# frozen_string_literal: true

class SalaryChange < ApplicationRecord
  belongs_to :employee
  validates :previous_amount_minor, :new_amount_minor, numericality: { only_integer: true, greater_than: 0 }
  validates :currency, :previous_currency, inclusion: { in: ->(_) { SalarySettings.supported_currencies } }
  validates :reason, presence: true, length: { maximum: 500 }
  validates :changed_by, presence: true
  before_update { raise ActiveRecord::ReadOnlyRecord, 'salary history is immutable' }
  before_destroy { raise ActiveRecord::ReadOnlyRecord, 'salary history is immutable' }
end
