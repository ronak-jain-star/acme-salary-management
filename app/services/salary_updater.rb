class SalaryUpdater
  Result = Struct.new(:salary, :change, :errors, keyword_init: true) do
    def success? = errors.empty?
  end

  def self.call(employee:, amount_minor: nil, currency: nil, reason: nil, changed_by: nil)
    amount = Integer(amount_minor.to_s, 10) rescue nil
    errors = []
    errors << "amount_minor must be a positive integer" unless amount&.positive?
    code = currency.to_s.upcase
    errors << "currency must be supported (USD, INR, GBP, EUR, SGD)" unless %w[USD INR GBP EUR SGD].include?(code)
    errors << "reason is required (max 500 characters)" if reason.to_s.strip.empty? || reason.to_s.length > 500
    errors << "changed_by is required" if changed_by.to_s.strip.empty?
    return Result.new(errors: errors) if errors.any?
    change = nil
    salary = nil
    employee.with_lock do
      salary = employee.current_salary
      return Result.new(errors: ["employee has no current salary"]) unless salary
      change = employee.salary_changes.create!(previous_amount_minor: salary.amount_minor, previous_currency: salary.currency, new_amount_minor: amount, currency: code, reason: reason.strip, changed_by: changed_by.strip)
      salary.update!(amount_minor: amount, currency: code)
    end
    Result.new(salary: salary, change: change, errors: [])
  rescue ActiveRecord::RecordInvalid => e
    Result.new(errors: e.record.errors.full_messages)
  end
end
