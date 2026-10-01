class SalaryUpdater
  Result = Struct.new(:salary, :change, :errors, keyword_init: true) do
    def success? = errors.empty?
  end

  def self.call(employee:, amount_minor: nil, currency: nil, reason: nil, changed_by: nil)
    attributes = normalize_attributes(amount_minor:, currency:, reason:, changed_by:)
    errors = validation_errors(attributes)
    return failure(errors) if errors.any?

    update_salary(employee, attributes)
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages)
  end

  def self.normalize_attributes(amount_minor:, currency:, reason:, changed_by:)
    {
      amount: parse_amount(amount_minor),
      currency: currency.to_s.upcase,
      reason: reason.to_s,
      changed_by: changed_by.to_s.strip
    }
  end
  private_class_method :normalize_attributes

  def self.parse_amount(amount_minor)
    Integer(amount_minor.to_s, 10)
  rescue ArgumentError
    nil
  end
  private_class_method :parse_amount

  def self.validation_errors(attributes)
    errors = []
    errors << "amount_minor must be a positive integer" unless attributes[:amount]&.positive?

    supported_currencies = SalarySettings.supported_currencies
    unless supported_currencies.include?(attributes[:currency])
      errors << "currency must be supported (#{supported_currencies.join(', ')})"
    end

    if attributes[:reason].strip.empty? || attributes[:reason].length > 500
      errors << "reason is required (max 500 characters)"
    end
    errors << "changed_by is required" if attributes[:changed_by].empty?
    errors
  end
  private_class_method :validation_errors

  def self.update_salary(employee, attributes)
    employee.with_lock do
      salary = employee.current_salary
      if salary.nil?
        failure([ "employee has no current salary" ])
      else
        change = create_salary_change(employee, salary, attributes)
        salary.update!(amount_minor: attributes[:amount], currency: attributes[:currency])
        Result.new(salary:, change:, errors: [])
      end
    end
  end
  private_class_method :update_salary

  def self.create_salary_change(employee, salary, attributes)
    employee.salary_changes.create!(
      previous_amount_minor: salary.amount_minor,
      previous_currency: salary.currency,
      new_amount_minor: attributes[:amount],
      currency: attributes[:currency],
      reason: attributes[:reason].strip,
      changed_by: attributes[:changed_by]
    )
  end
  private_class_method :create_salary_change

  def self.failure(errors)
    Result.new(errors:)
  end
  private_class_method :failure
end
