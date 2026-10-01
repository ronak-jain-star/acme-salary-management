require "rails_helper"

RSpec.describe SalaryUpdater do
  before_all do
    @successful_employee = create(:employee)
    @invalid_amount_employee = create(:employee)
    @validation_employee = create(:employee)
    @long_reason_employee = create(:employee)
    @salaryless_employee = create(:employee)
    @salaryless_employee.current_salary.destroy!
  end

  it "updates salary and appends an audit row" do
    employee = @successful_employee
    result = described_class.call(employee: employee, amount_minor: "12500000", currency: "USD",
reason: "Merit increase", changed_by: "HR")
    expect(result).to be_success
    expect(employee.current_salary.reload.amount_minor).to eq(12_500_000)
    expect(employee.salary_changes.count).to eq(1)
    expect(employee.salary_changes.first).to have_attributes(previous_amount_minor: 10_000_000,
previous_currency: "USD", new_amount_minor: 12_500_000, currency: "USD", reason: "Merit increase", changed_by: "HR")
  end

  it "rejects a non-positive or non-integer amount without changing salary" do
    employee = @invalid_amount_employee
    result = described_class.call(employee: employee, amount_minor: "-1", currency: "USD", reason: "Correction",
changed_by: "HR")
    expect(result).not_to be_success
    expect(result.errors).to include("amount_minor must be a positive integer")
    expect(employee.current_salary.reload.amount_minor).to eq(10_000_000)
    expect(employee.salary_changes).to be_empty

    result = described_class.call(employee: employee, amount_minor: "1.25", currency: "USD", reason: "Correction",
changed_by: "HR")
    expect(result.errors).to include("amount_minor must be a positive integer")
  end

  it "requires a supported currency, a reason, and a changed_by value" do
    employee = @validation_employee
    result = described_class.call(employee: employee, amount_minor: "1", currency: "US dollars", reason: " ",
changed_by: "HR")
    expect(result.errors).to include("currency must be supported (USD, INR, GBP, EUR, SGD)",
"reason is required (max 500 characters)")

    result = described_class.call(employee: employee, amount_minor: "1", currency: "USD", reason: "Valid reason",
changed_by: " ")
    expect(result.errors).to include("changed_by is required")
  end

  it "rejects a reason longer than 500 characters" do
    result = described_class.call(employee: @long_reason_employee, amount_minor: "1", currency: "USD", reason: "a" * 501,
changed_by: "HR")

    expect(result.errors).to include("reason is required (max 500 characters)")
  end

  it "returns an error when the employee has no current salary" do
    employee = @salaryless_employee
    result = described_class.call(employee: employee, amount_minor: "1", currency: "USD", reason: "Correction",
changed_by: "HR")

    expect(result.errors).to include("employee has no current salary")
    expect(employee.salary_changes).to be_empty
  end
end
