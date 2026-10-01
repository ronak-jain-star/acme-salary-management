# frozen_string_literal: true

class SalaryChangeBlueprint < Blueprinter::Base
  identifier :id

  fields :previous_amount_minor, :previous_currency, :new_amount_minor, :currency,
    :reason, :changed_by, :created_at
end
