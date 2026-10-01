# frozen_string_literal: true

class SalaryUpdater
  Result = Struct.new(:salary, :change, :errors, keyword_init: true) do
    def success? = errors.empty?
  end

  def self.call(employee:, amount_minor: nil, currency: nil, reason: nil, changed_by: nil)
    new(employee:, amount_minor:, currency:, reason:, changed_by:).call
  end

  def initialize(employee:, amount_minor:, currency:, reason:, changed_by:)
    @employee = employee
    @amount_minor = amount_minor
    @currency = currency
    @reason = reason
    @changed_by = changed_by
  end

  def call
    attributes = normalize_attributes
    errors = validation_errors(attributes)
    return failure(errors) if errors.any?

    update_salary(attributes)
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages)
  end

  private

  def normalize_attributes
    {
      amount: parse_amount(@amount_minor),
      currency: @currency.to_s.upcase,
      reason: @reason.to_s,
      changed_by: @changed_by.to_s.strip
    }
  end

  def parse_amount(amount_minor)
    Integer(amount_minor.to_s, 10)
  rescue ArgumentError
    nil
  end

  def validation_errors(attributes)
    errors = []
    errors << I18n.t('salary_updater.errors.amount_minor') unless attributes[:amount]&.positive?

    supported_currencies = SalarySettings.supported_currencies
    unless supported_currencies.include?(attributes[:currency])
      errors << I18n.t('salary_updater.errors.currency', currencies: supported_currencies.join(', '))
    end

    if attributes[:reason].strip.empty? || attributes[:reason].length > 500
      errors << I18n.t('salary_updater.errors.reason')
    end
    errors << I18n.t('salary_updater.errors.changed_by') if attributes[:changed_by].empty?
    errors
  end

  def update_salary(attributes)
    @employee.with_lock do
      salary = @employee.current_salary
      if salary.nil?
        failure([ I18n.t('salary_updater.errors.missing_current_salary') ])
      else
        change = create_salary_change(salary, attributes)
        salary.update!(amount_minor: attributes[:amount], currency: attributes[:currency])
        Result.new(salary:, change:, errors: [])
      end
    end
  end

  def create_salary_change(salary, attributes)
    @employee.salary_changes.create!(
      previous_amount_minor: salary.amount_minor,
      previous_currency: salary.currency,
      new_amount_minor: attributes[:amount],
      currency: attributes[:currency],
      reason: attributes[:reason].strip,
      changed_by: attributes[:changed_by]
    )
  end

  def failure(errors)
    Result.new(errors:)
  end
end
